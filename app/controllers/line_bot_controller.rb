class LineBotController < ApplicationController
  skip_before_action :verify_authenticity_token

  def callback
    body = request.body.read
    signature = request.headers['X-Line-Signature']
  
    unless client.validate_signature(body, signature)
      render json: { message: 'Invalid signature' }, status: 401 and return
    end
  
    events = client.parse_events_from(body)
    events.each { |event|
        user_id = event['source']['userId']
        user = User.where(uid: user_id)[0]
       # 初期化
    message = "「登録」と打つとマイコスメに登録ができます。\n「成分」と打つと注意する成分が含まれているか確認できます。"

    if event.message['text'].include?("登録")
      message = handle_message(event)
    elsif event.message['text'].include?("成分")
      message = ingredient_message(event)
    end

    case event
    when Line::Bot::Event::Message
      case event.type
      when Line::Bot::Event::MessageType::Text
        client.reply_message(event['replyToken'], message)
      end
    end
  }


    head :ok
  end

  def handle_message(event)
    user_id = event['source']['userId']
    @current_user = User.find_by(uid: user_id)
    user_message = event.message['text']
    reply_token = event['replyToken']

        if user_message.downcase == '登録'
          send_message(reply_token, "化粧品名を打ってください")
        else
          register_cosmetic(user_message, reply_token)
        end
  
  end

  def ingredient_message(event)
    user_id = event['source']['userId']
    @current_user = User.find_by(uid: user_id)

        user_message = event.message['text']
      reply_token = event['replyToken']

        if user_message.downcase == '成分'
          send_message(reply_token, "化粧品名を打ってください")
        else
        cosmetic_ingredient(user_message, reply_token)
        end
   
    
  end
  
  def register_cosmetic(user_input, reply_token)
    cosmetic = Cosmetic.find_by(product_name: user_input)
  
    if cosmetic.nil?
      send_message(reply_token, "申し訳ありません。\n#{user_input}は見つかりませんでした。")
    else
      mycosmetic = Mycosmetic.find_by(user_id: @current_user.id, cosmetic_id: cosmetic.id)
  
      if mycosmetic.present?
        send_message(reply_token, "登録内容:\n 使用状況: #{mycosmetic.usage_situation}\n 開始日: #{mycosmetic.starting_date}\n 問題: #{mycosmetic.problem}\n メモ: #{mycosmetic.memo}")
      else
        send_message(reply_token, "#{cosmetic.product_name}を登録します。\n使用状況を入力してください。")
        # ここで他の情報も収集する処理を追加する
      end
    end
  end

  def cosmetic_ingredient(user_input, reply_token)
    cosmetic = Cosmetic.find_by(product_name: user_input)
  
    if cosmetic.nil?
      send_message(reply_token, "申し訳ありません。\n#{user_input}は見つかりませんでした。")
    else
      warning_ingredients = get_active_warning_ingredients(cosmetic)

      if warning_ingredients.empty?
        send_message(reply_token, "注意する成分はありません。")
      else
        message = "この化粧品には以下の成分が含まれています。注意が必要です:\n\n"
        warning_ingredients.each do |ingredient|
          message += "- #{ingredient}\n"
        end
      send_message(reply_token, message)
      end
    end
  end

  def send_message(reply_token, text)
    message = {
      type: 'text',
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
  # Find the profile associated with the current user
  profile = current_user.profile

  return [] unless profile

  # Get the checked caution ingredients and allergy ingredients from the profile
  checked_caution_ingredients = profile.ingredients.pluck(:name)
  allergy_ingredients = profile.allergy&.split(",")&.map(&:strip) || []

  # Combine the caution and allergy ingredients and remove duplicates
  (checked_caution_ingredients + allergy_ingredients).uniq & cosmetic.ingredients.pluck(:name)
  end
end
