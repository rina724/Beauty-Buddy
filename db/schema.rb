# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2024_10_13_172628) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_brands_on_name", unique: true
  end

  create_table "categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "cosmetics", force: :cascade do |t|
    t.string "product_name", null: false
    t.string "image", null: false
    t.bigint "category_id"
    t.bigint "brand_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["brand_id"], name: "index_cosmetics_on_brand_id"
    t.index ["category_id"], name: "index_cosmetics_on_category_id"
    t.index ["product_name"], name: "index_cosmetics_on_product_name", unique: true
  end

  create_table "daily_report_cosmetics", force: :cascade do |t|
    t.bigint "daily_report_id"
    t.bigint "mycosmetic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["daily_report_id", "mycosmetic_id"], name: "index_on_daily_report_id_and_mycosmetic_id"
    t.index ["daily_report_id"], name: "index_daily_report_cosmetics_on_daily_report_id"
    t.index ["mycosmetic_id"], name: "index_daily_report_cosmetics_on_mycosmetic_id"
  end

  create_table "daily_reports", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "start_time", null: false
    t.integer "health"
    t.text "memo"
    t.integer "date_amount"
    t.bigint "mycosmetic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mycosmetic_id"], name: "index_daily_reports_on_mycosmetic_id"
    t.index ["user_id", "start_time"], name: "index_daily_reports_on_user_id_and_start_time", unique: true
    t.index ["user_id"], name: "index_daily_reports_on_user_id"
  end

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "cosmetic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cosmetic_id"], name: "index_favorites_on_cosmetic_id"
    t.index ["user_id"], name: "index_favorites_on_user_id"
  end

  create_table "mycosmetics", force: :cascade do |t|
    t.boolean "usage_situation"
    t.date "starting_date"
    t.integer "problem"
    t.text "memo"
    t.bigint "user_id"
    t.bigint "cosmetic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cosmetic_id"], name: "index_mycosmetics_on_cosmetic_id"
    t.index ["user_id"], name: "index_mycosmetics_on_user_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "caution"
    t.string "allergy"
    t.bigint "mycosmetic_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mycosmetic_id"], name: "index_profiles_on_mycosmetic_id"
    t.index ["user_id"], name: "index_profiles_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "name", default: "", null: false
    t.string "avatar", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "cosmetics", "brands"
  add_foreign_key "cosmetics", "categories"
  add_foreign_key "daily_report_cosmetics", "daily_reports"
  add_foreign_key "daily_report_cosmetics", "mycosmetics"
  add_foreign_key "daily_reports", "mycosmetics"
  add_foreign_key "daily_reports", "users"
  add_foreign_key "favorites", "cosmetics"
  add_foreign_key "favorites", "users"
  add_foreign_key "mycosmetics", "cosmetics"
  add_foreign_key "mycosmetics", "users"
  add_foreign_key "profiles", "mycosmetics"
  add_foreign_key "profiles", "users"
end
