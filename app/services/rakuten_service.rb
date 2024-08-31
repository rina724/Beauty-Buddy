class RakutenService
  def self.fetch_cosmetics
    cosmetics = []

    # ここで全ての化粧品情報を取得
    Cosmetic.all.each do |cosmetic|
      response = RakutenWebService::Ichiba::Item.search(
        keyword: "#{cosmetic.product_name} #{cosmetic.brand.name}"
      )

      # 取得した情報の中から最初のアイテムを使う（必要に応じて変更）
      if response.present?
        item = response.first
        image_url = nil

        # smallImageUrlsまたはmediumImageUrlsから画像URLを取得
        if item["smallImageUrls"].any?
          image_url = item["smallImageUrls"].first["imageUrl"]
        elsif item["mediumImageUrls"].any?
          image_url = item["mediumImageUrls"].first["imageUrl"]
        end

        cosmetics << {
          product_name: item["itemName"],
          brand: item["brand"],
          image: image_url
        }
      end
    end

    cosmetics
  end
end
