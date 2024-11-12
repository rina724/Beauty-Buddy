class LineBotController < ApplicationController
  skip_before_action :verify_authenticity_token

  def callback
    body = request.body.read
    signature = request.headers["X-Line-Signature"]

    unless client.validate_signature(body, signature)
      render json: { message: "Invalid signature" }, status: 401 and return
    end

    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          user_id = event["source"]["userId"]
          @current_user = User.find_by(uid: user_id)

          if event.message["text"].include?("登録")
            handle_registration(event)
          elsif event.message["text"].include?("成分")
            handle_ingredient(event)
          else
            send_message(event["replyToken"], "申し訳ありません。正しいコマンドを入力してください。")
          end
        end
      end
    end

    head :ok
  end

  def handle_registration(event)
    user_input = event.message["text"]
    reply_token = event["replyToken"]

    # 「登録」という単語だけの場合
    if user_input.strip == "登録"
      send_message(reply_token, "化粧品名も含めたメッセージを送ってください")
    end

    # 「登録」を除いた商品名を取得
    product_name = user_input.gsub("登録", "").strip

    cosmetic = Cosmetic.find_by(product_name: product_name)

    if cosmetic.nil?
      send_message(reply_token, "申し訳ありません。\n#{product_name}は見つかりませんでした。")
    else
      mycosmetic = Mycosmetic.find_by(user_id: @current_user.id, cosmetic_id: cosmetic.id)

      if mycosmetic.present?
        usage_message = I18n.t("activerecord.attributes.mycosmetic.usage.#{mycosmetic.usage_situation}")
        problem_message = I18n.t("enums.mycosmetic.problem.#{mycosmetic.problem}")
        starting_date_message = mycosmetic.starting_date.strftime(I18n.t("date.formats.long"))

        send_message(reply_token, "登録内容:\n 使用状況: #{usage_message}\n 開始日: #{starting_date_message}\n 問題: #{problem_message}\n メモ: #{mycosmetic.memo}")
      else
        send_message(reply_token, "#{cosmetic.product_name}を登録します。\n使用状況を入力してください。")
      end
    end
  end

  def handle_ingredient(event)
    user_input = event.message["text"]
    reply_token = event["replyToken"]

    # 「成分」という単語だけの場合
    if user_input.strip == "成分"
      send_message(reply_token, "化粧品名も含めたメッセージを送ってください")
      return
    end

    # 「成分」を除いた商品名を取得
    product_name = user_input.gsub("成分", "").strip

    cosmetic = Cosmetic.find_by(product_name: product_name)

    if cosmetic.nil?
      send_message(reply_token, "申し訳ありません。\n#{product_name}は見つかりませんでした。")
    else
      warning_ingredients = get_active_warning_ingredients(cosmetic)

      if warning_ingredients.empty?
        send_message(reply_token, "注意する成分はありません。")
      else
        message = "この化粧品には以下の注意する成分が含まれています。\n\n"
        warning_ingredients.each do |ingredient|
          message += "- #{ingredient}\n"
        end
        send_message(reply_token, message)
      end
    end
  end

  def send_message(reply_token, text)
    message = {
      type: "text",
      text: text
    }

    client.reply_message(reply_token, message)
  end

  private

  def client
    @client ||= Line::Bot::Client.new do |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    end
  end

  def get_active_warning_ingredients(cosmetic)
    profile = @current_user.profile
    return [] unless profile

    checked_caution_ingredients = profile.ingredients.pluck(:name)
    allergy_ingredients = profile.allergy&.split(",")&.map(&:strip) || []

    (checked_caution_ingredients + allergy_ingredients).uniq & cosmetic.ingredients.pluck(:name)
  end
end
