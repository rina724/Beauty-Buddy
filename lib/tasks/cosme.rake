namespace :cosme do
  task cosme: :environment do
    sheet = Google::Spreadsheets.new

    # productsシートからproduct_nameとcosmetic_idを取得
    products = sheet.get_values(ENV["SHEET_ID"], ["products!A2:B"]).values

    # categoriesシートからcategoryを取得
    categories = sheet.get_values(ENV["SHEET_ID"], ["categories!A2:B"]).values

    # ingredientsシートからingredientsを取得
    ingredients = sheet.get_values(ENV["SHEET_ID"], ["ingredients!A2:B"]).values

    # Process products
    products.each do |cosmetic_id, product_name|
      next if cosmetic_id.blank?
      # Fetch brand and image from Rakuten API
      brand_name, image_url = fetch_from_rakuten(product_name)

      # Find or create brand
      brand = Brand.find_or_create_by!(name: brand_name)

      # Create or update cosmetic
      cosmetic = Cosmetic.find_or_initialize_by(id: cosmetic_id)
      cosmetic.assign_attributes(
        product_name: product_name,
        brand: brand,
        image: image_url
      )

      # Process categories for this cosmetic
      category = process_categories(categories, cosmetic_id)
      cosmetic.category = category if category

      # Save the cosmetic
      if cosmetic.save
        puts "Processed cosmetic: #{product_name}"
        
        # Process ingredients for this cosmetic
        process_ingredients(ingredients, cosmetic)
      else
        puts "Failed to process cosmetic: #{product_name}. Errors: #{cosmetic.errors.full_messages.join(', ')}"
      end
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