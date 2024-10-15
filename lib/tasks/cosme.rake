namespace :cosme do
  task fetch_data: :environment do
    sheet = Google::Spreadsheets.new
    products = sheet.get_values(ENV["SHEET_ID"], ["products!A2:B"]).values
    categories = sheet.get_values(ENV["SHEET_ID"], ["categories!A2:B"]).values
    ingredients = sheet.get_values(ENV["SHEET_ID"], ["ingredients!A2:B"]).values

    File.write('tmp/products.json', products.to_json)
    File.write('tmp/categories.json', categories.to_json)
    File.write('tmp/ingredients.json', ingredients.to_json)
  end

  task process_products: :environment do
    products = JSON.parse(File.read('tmp/products.json'))
    categories = JSON.parse(File.read('tmp/categories.json'))

    products.each_slice(100) do |batch|
      batch.each do |cosmetic_id, product_name|
        next if cosmetic_id.blank?
        
        brand_name, image_url = fetch_from_rakuten(product_name)
        brand = Brand.find_or_create_by!(name: brand_name)
        
        cosmetic = Cosmetic.find_or_initialize_by(id: cosmetic_id)
        cosmetic.assign_attributes(
          product_name: product_name,
          brand: brand,
          image: image_url
        )
        
        category = process_categories(categories, cosmetic_id)
        cosmetic.category = category if category
        
        cosmetic.save
      end
      GC.start
    end
  end

  task process_ingredients: :environment do
    ingredients = JSON.parse(File.read('tmp/ingredients.json'))
    
    Cosmetic.find_each(batch_size: 100) do |cosmetic|
      process_ingredients(ingredients, cosmetic)
      GC.start
    end
  end

  def fetch_from_rakuten(product_name)
    app_id = ENV['RAKUTEN_APP_ID']
    encoded_keyword = URI.encode_www_form_component(product_name)
    url = "https://app.rakuten.co.jp/services/api/Product/Search/20170426?applicationId=#{app_id}&keyword=#{encoded_keyword}"
    
    response = Net::HTTP.get(URI(url))
    result = JSON.parse(response)

    brand_name = 'Unknown'
    image_url = "25072237.png"
  
    if result['Products'] && result['Products'].any?
      product = result['Products'][0]['Product']
      
      # ブランド名の取得
      brand_name = product['brandName'].presence || product['makerName'].presence || 'Unknown'
      
      # 画像URLの取得
      image_url = product['mediumImageUrl'] if product['mediumImageUrl'].present?
      image_url = product['smallImageUrl'] if image_url == "25072237.png" && product['smallImageUrl'].present?
    end
  
    [brand_name, image_url]
  end

  def process_categories(categories, cosmetic_id)
    category_name = categories.find { |id, _| id == cosmetic_id.to_s }&.last
    Category.find_or_create_by(name: category_name) if category_name
  end

  def process_ingredients(ingredients, cosmetic)
    ingredients.select { |id, _| id == cosmetic.id.to_s }.each do |_, ingredient_name|
      ingredient = Ingredient.find_or_create_by!(name: ingredient_name)
      CosmeticIngredient.find_or_create_by!(cosmetic: cosmetic, ingredient: ingredient)
    end
  end
end