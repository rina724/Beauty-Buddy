namespace :cosmetic do
  task cosmetic: :environment do
    sheet = Google::Spreadsheets.new
    val = sheet.get_values(ENV["SHEET_ID"], [ "Data!A2:E" ]).values

    val.each do |product_name, amount, category_name, brand_name, ingredient|
      category_id = Category.find_by(name: category_name)&.id
      brand_id = Brand.find_by(name: brand_name)&.id

      # ここから楽天市場APIを使って画像を取得する処理を追加する
      app_id = ENV["RAKUTEN_APP_ID"] # 取得したアプリIDをここに入れる
      encoded_keyword = URI.encode_www_form_component("#{product_name} #{brand_name}") # keywordをエンコード
      url = "https://app.rakuten.co.jp/services/api/IchibaItem/Search/20170706?applicationId=#{app_id}&keyword=#{encoded_keyword}"
      response = Net::HTTP.get(URI(url))
      result = JSON.parse(response)

      # 画像URLを取得
      image_url = nil
      if result["Items"] && result["Items"].any?
        item = result["Items"][0]["Item"]
        if item["mediumImageUrls"] && item["mediumImageUrls"].any?
          image_url = item["mediumImageUrls"][0]["imageUrl"]
        elsif item["smallImageUrls"] && item["smallImageUrls"].any?
          image_url = item["smallImageUrls"][0]["imageUrl"]
        end
      end

      # image_urlがnilの場合にデフォルト値を設定する
      image_url ||= "25072237.png" # デフォルトの画像URLを設定

      # Cosmeticモデルを探す
      cosmetic = Cosmetic.find_or_initialize_by(product_name: product_name) do |c|
        c.amount = amount
        c.category_id = category_id
        c.brand_id = brand_id
        c.ingredient = ingredient
        c.image = image_url # 取得した画像URLをセット
      end

      # 保存する
      cosmetic.save! if cosmetic.new_record? || cosmetic.changed?
    end
  end
end
