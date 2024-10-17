require 'google/apis/sheets_v4'
require 'net/http'
require 'json'

namespace :cosme do
  task import_products: :environment do
    service = Google::Apis::SheetsV4::SheetsService.new
    service.key = ENV['GOOGLE_SHEETS_API_KEY']
    spreadsheet_id = ENV['SHEET_ID']
    range = "products!A2:B"

    response = service.get_spreadsheet_values(spreadsheet_id, range)
    
    response.values.each do |cosmetic_id, product_name|
      next if cosmetic_id.to_i < 29771
      
      Cosmetic.find_or_create_by!(id: cosmetic_id) do |cosmetic|
        cosmetic.product_name = product_name
      end
    end

    puts "Imported #{Cosmetic.count} products"
  end

  task import_categories: :environment do
    service = Google::Apis::SheetsV4::SheetsService.new
    service.key = ENV['GOOGLE_SHEETS_API_KEY']
    spreadsheet_id = ENV['SHEET_ID']
    range = "categories!A2:B"

    response = service.get_spreadsheet_values(spreadsheet_id, range)
    
    response.values.each do |cosmetic_id, category_name|
      next if cosmetic_id.to_i < 29771

      cosmetic = Cosmetic.find_by(id: cosmetic_id)
      next unless cosmetic

      category = Category.find_or_create_by!(name: category_name)
      cosmetic.update(category: category)
    end

    puts "Imported categories for #{Cosmetic.where.not(category_id: nil).count} products"
  end

  task import_ingredients: :environment do
    service = Google::Apis::SheetsV4::SheetsService.new
    service.key = ENV['GOOGLE_SHEETS_API_KEY']
    spreadsheet_id = ENV['SHEET_ID']
    range = "ingredients!A2:B"

    response = service.get_spreadsheet_values(spreadsheet_id, range)
    
    response.values.each do |cosmetic_id, ingredient_name|
      next if cosmetic_id.to_i < 29771

      cosmetic = Cosmetic.find_by(id: cosmetic_id)
      next unless cosmetic

      ingredient = Ingredient.find_or_create_by!(name: ingredient_name)
      CosmeticIngredient.find_or_create_by!(cosmetic: cosmetic, ingredient: ingredient)
    end

    puts "Imported ingredients for #{Cosmetic.joins(:cosmetic_ingredients).distinct.count} products"
  end

  task fetch_rakuten_info: :environment do
    Cosmetic.find_each do |cosmetic|
      brand_name, image_url = fetch_from_rakuten(cosmetic.product_name)

      brand = Brand.find_or_create_by!(name: brand_name)
      
      cosmetic.update(
        brand: brand,
        image: image_url
      )

      puts "Updated Rakuten info for product: #{cosmetic.product_name}"
      sleep 1  # APIレート制限を考慮して1秒待機
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
      
      brand_name = product['brandName'].presence || product['makerName'].presence || 'Unknown'
      
      image_url = product['mediumImageUrl'] if product['mediumImageUrl'].present?
      image_url = product['smallImageUrl'] if image_url == "25072237.png" && product['smallImageUrl'].present?
    end

    [brand_name, image_url]
  end
end