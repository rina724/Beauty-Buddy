require 'thread'
require 'webrick'

class CosmeProcessor
  def initialize(categories, ingredients)
    @categories = categories
    @ingredients = ingredients
    @mutex = Mutex.new
  end

  def process(batch)
    batch.each do |cosmetic_id, product_name|
      next if cosmetic_id.blank?

      puts "Processing cosmetic_id: #{cosmetic_id}"

      ActiveRecord::Base.transaction do
        brand_name, image_url = fetch_from_rakuten(product_name)
        brand = Brand.find_or_create_by!(name: brand_name)

        cosmetic = Cosmetic.find_or_initialize_by(id: cosmetic_id)
        cosmetic.assign_attributes(
          product_name: product_name,
          brand: brand,
          image: image_url
        )

        category = process_categories(cosmetic_id)
        cosmetic.category = category if category

        if cosmetic.save
          puts "Processed cosmetic: #{product_name}"
          process_ingredients(cosmetic)
        else
          puts "Failed to process cosmetic: #{product_name}. Errors: #{cosmetic.errors.full_messages.join(', ')}"
        end
      end
    end
  end

  private

  def fetch_from_rakuten(product_name)
    # 既存のfetch_from_rakutenメソッドの内容をここに移動
  end

  def process_categories(cosmetic_id)
    category_name = @categories.find { |id, _| id == cosmetic_id.to_s }&.last
    Category.find_or_create_by(name: category_name) if category_name
  end

  def process_ingredients(cosmetic)
    ingredient_data = @ingredients.select { |id, _| id == cosmetic.id.to_s }.map do |_, ingredient_name|
      { name: ingredient_name }
    end

    @mutex.synchronize do
      Ingredient.upsert_all(ingredient_data, unique_by: :name)

      cosmetic_ingredient_data = ingredient_data.map do |data|
        { cosmetic_id: cosmetic.id, ingredient_id: Ingredient.find_by(name: data[:name]).id }
      end

      CosmeticIngredient.upsert_all(cosmetic_ingredient_data, unique_by: [:cosmetic_id, :ingredient_id])
    end
  end
end

namespace :cosme do
  task optimize: :environment do
    sheet = Google::Spreadsheets.new
    batch_size = 50
    thread_count = 2  # スレッド数を設定

    categories = sheet.get_values(ENV["SHEET_ID"], ["categories!A2:B"]).values
    products = sheet.get_values(ENV["SHEET_ID"], ["products!A2:B"]).values
    ingredients = sheet.get_values(ENV["SHEET_ID"], ["ingredients!A2:B"]).values

    valid_cosmetic_ids = categories.map { |id, _| id.to_i }.select { |id| id >= 29771 }.to_set

    filtered_products = products.select { |id, _| valid_cosmetic_ids.include?(id.to_i) }
    filtered_categories = categories.select { |id, _| valid_cosmetic_ids.include?(id.to_i) }
    filtered_ingredients = ingredients.select { |id, _| valid_cosmetic_ids.include?(id.to_i) }

    processor = CosmeProcessor.new(filtered_categories, filtered_ingredients)

    server = WEBrick::HTTPServer.new(Port: ENV['PORT'] || 3000)
    server.mount_proc '/' do |req, res|
      res.body = 'Cosme optimization task is running'
    end

    # タスク完了後にサーバーを停止するためのシャットダウンフック
    trap 'INT' do server.shutdown end

    # バックグラウンドでタスクを実行
    Thread.new do
      # 既存の処理コード（スレッド作成とjoinなど）をここに配置
      
      # タスク完了後にサーバーをシャットダウン
      server.shutdown
    end

    # メインスレッドでサーバーを起動
    server.start
  end
end