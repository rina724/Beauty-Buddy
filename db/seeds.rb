# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Category.create!(
  [
    { name: '洗顔料' },
    { name: 'クレンジング' },
    { name: '化粧水' },
    { name: '乳液' },
    { name: '美容液' },
    { name: 'フェイスクリーム' },
    { name: 'フェイスオイル' },
    { name: 'オールインワン化粧品' },
    { name: 'フェイスバーム' },
    { name: 'パック・フェイスマスク' },
    { name: '日焼け止め' },
    { name: 'まつ毛美容液' },
    { name: 'アイケア・アイクリーム' },
    { name: 'リップクリーム' },
    { name: '化粧下地' },
    { name: 'コンシーラー' },
    { name: 'ファンデーション' },
    { name: 'フェイスパウダー' },
    { name: '口紅・グロス・リップライナー' },
    { name: 'チーク' },
    { name: 'アイシャドウ' },
    { name: 'アイライナー' },
    { name: 'マスカラ' },
    { name: 'アイブロウ' },
    { name: 'シャンプー・コンディショナー' },
    { name: 'ヘアパック・トリートメント' }
  ]
)

Brand.create!(
  [
    { name: 'オードムーゲ' },
    { name: 'なめらか本舗' },
    { name: 'キャンメイク' },
    { name: 'KATE' },
    { name: 'ちふれ' },
    { name: 'ファンケル' },
    { name: 'ダイアン' }
  ]
)
