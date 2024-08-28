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

categories = Category.all
brands = Brand.all

cosmetics = [
  { product_name: 'ダイアン パーフェクトビューティ モイストダイアン エクストラダメージリペア シャンプー', 
    amount: 450, 
    ingredient:'水, オレフィン(C14-16)スルホン酸Na, コカミドプロピルベタイン, コカミドメチルMEA, ココイルグルタミン酸TEA, ココイル加水分解ケラチンK, ヤシ油脂肪酸PEG-7グリセリル, ミリスタミンオキシド, ココアンホ酢酸Na, ココイルメチルタウリンNa, γ-ドコサラクトン, クオタニウム-18, クオタニウム-33, コレステロール, セラミドEOP, セラミドNG, セラミドNP, セラミドAG, セラミドAP, PG, 加水分解ケラチン, アルガニアスピノサ核油, マンゴー種子油, テオブロマグランジフロルム種子脂, プルーン種子エキス, カラパグアイアネンシス種子油, スクレロカリアビレア種子油, バオバブ種子油, オプンチアフィクスインジカ種子油, ステアルジモニウムヒドロキシプロピル加水分解ケラチン, ポウテリアサポタ種子脂, ケラチン, イソステアロイル加水分解ケラチン, アラニン, ヒドロキシプロリン, PCA-Na, セテアラミドエチルジエトニウム加水分解コメタンパク, ヒアルロン酸Na, ヒアルロン酸ヒドロキシプロピルトリモニウム, 加水分解ヒアルロン酸, 加水分解ハチミツタンパク, リンゴ果実培養細胞エキス, アルガニアスピノサ芽細胞エキス, ロドデンドロンフェルギネウム葉培養細胞エキス, コラーゲン, 加水分解コンキオリン, シクロヘキサン-1,4-ジカルボン酸ビスエトキシジグリコール, プロパンジオール, DPG, BG, イソマルト, ポリクオタニウム-10, イソノナン酸イソノニル, ダイズステロール, 塩化Na, キサンタンガム, レシチン, ベヘントリモニウムクロリド, グリセリン, クエン酸, 乳酸, トコフェロール, EDTA-2Na, 安息香酸Na, フェノキシエタノール, 香料, カラメル',
    category_id: categories.find { |c| c.name == 'シャンプー・コンディショナー' }.id, 
    brand_id: brands.find { |b| b.name == 'ダイアン' }.id 
  },
  { product_name: '洗顔パウダー', 
    amount: 50, 
    ingredient: '(ヤシ脂肪酸/パーム脂肪酸/ヒマワリ脂肪酸)グルタミン酸Na, ラウロイルグルタミン酸Na, マンニトール, コーンスターチ, グルコース, PEG-75, ラウロイルアスパラギン酸Na, プルラン, ミリスチン酸Na, コメデンプン, ベヘニルアルコール, ミリスチン酸K, ヒドロキシプロピルメチルセルロース, タルク, α-グルカン, ミリストイルグルタミン酸Na, ラウリン酸Na, カンテン, ラウリン酸K, ヒドロキシプロピルデンプンリン酸, アミノエタンスルフィン酸, ステアリン酸, ラウラミドプロピルアミンオキシド, シリカ, セリン, ソルビトール, グリセリン, アラントイン, デキストランヒドロキシプロピルトリモニウムクロリド, パルミチン酸K, パルミチン酸Na, ラウリン酸, オレイン酸ポリグリセリル-10, トコフェロール', 
    category_id: categories.find { |c| c.name == '洗顔料' }.id, 
    brand_id: brands.find { |b| b.name == 'ファンケル' }.id }
]
Cosmetic.create!(cosmetics)