namespace :cosme do
  task cosme: :environment do
    sheet = Google::Spreadsheets.new
    batch_size = 100  # バッチサイズを設定

    # categoriesシートからcategoryを取得
    categories = sheet.get_values(ENV["SHEET_ID"], ["categories!A2:B"]).values
    products = sheet.get_values(ENV["SHEET_ID"], ["products!A2:B"]).values
    ingredients = sheet.get_values(ENV["SHEET_ID"], ["ingredients!A2:B"]).values

    # cosmetic_idが29771以上のデータのみをフィルタリング
    valid_cosmetic_ids = categories.map { |id, _| id.to_i }.select { |id| id >= 29771 }.to_set

    filtered_products = products.select { |id, _| valid_cosmetic_ids.include?(id.to_i) }
    filtered_categories = categories.select { |id, _| valid_cosmetic_ids.include?(id.to_i) }
    filtered_ingredients = ingredients.select { |id, _| valid_cosmetic_ids.include?(id.to_i) }

    filtered_products.each_slice(batch_size) do |batch|
      process_batch(batch, filtered_categories, filtered_ingredients)
      GC.start  # 各バッチ後にガベージコレクションを実行
    end
  end

  def process_batch(batch, categories, ingredients)
    batch.each do |cosmetic_id, product_name|
      next if cosmetic_id.blank?

      puts "Processing cosmetic_id: #{cosmetic_id}"  # デバッグ用出力

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

      if cosmetic.save
        puts "Processed cosmetic: #{product_name}"
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