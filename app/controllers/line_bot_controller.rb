class LineBotController < ApplicationController
  skip_before_action :verify_authenticity_token

  def callback
    body = request.body.read
    line_event = JSON.parse(body)

    line_event['events'].each do |event|
      if event['type'] == 'message' && event['message']['type'] == 'text'
        received_cosmetic_name = event['message']['text']
        

        # ユーザーが存在しているか確認
        if current_user
          # 化粧品を検索
          cosmetics = Cosmetic.where("product_name LIKE ?", "%#{received_cosmetic_name}%")

          if cosmetics.empty?
            client.reply_message(event['replyToken'], "化粧品「#{received_cosmetic_name}」は見つかりませんでした。")
          elsif cosmetics.count == 1
            cosmetic = cosmetics.first
            mycosmetic = Mycosmetic.find_by(user_id: current_user.id, cosmetic_id: cosmetic.id)

            if mycosmetic
              client.reply_message(
                event['replyToken'],
                "化粧品「#{received_cosmetic_name}」は登録済みです:\n" \
                "使用状況: #{mycosmetic.usage_situation}\n" \
                "開始日: #{mycosmetic.starting_date}\n" \
                "問題点: #{mycosmetic.problem}\n" \
                "メモ: #{mycosmetic.memo}"
              )
            else
              Mycosmetic.create(
                user_id: current_user.id,
                cosmetic_id: cosmetic.id,
                usage_situation: nil,
                starting_date: nil,
                problem: nil,
                memo: nil
              )
              client.reply_message(event['replyToken'], "化粧品「#{received_cosmetic_name}」をマイコスメに登録しました。")
            end
          else
            cosmetic_options = cosmetics.map { |c| "- #{c.product_name}" }.join("\n")
            client.reply_message(
              event['replyToken'],
              "以下の化粧品が見つかりました。どれを登録しますか?\n\n#{cosmetic_options}"
            )
          end
        else
          client.reply_message(event['replyToken'], "新規登録してください。")
        end
      end
    end

    head :ok
  end

  private

  


  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end
  end
end
