# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_01_26_072328) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "photos", force: :cascade do |t|
    t.string "image"
    t.integer "sake_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "sakes", force: :cascade do |t|
    t.string "name"
    t.string "kura"
    t.date "bindume_date"
    t.date "brew_year"
    t.string "todofuken"
    t.integer "taste_value"
    t.integer "aroma_value"
    t.float "nihonshudo"
    t.float "sando"
    t.text "aroma_impression"
    t.string "color"
    t.text "taste_impression"
    t.string "nigori"
    t.string "awa"
    t.integer "tokutei_meisho", default: 0
    t.string "genryomai"
    t.string "kakemai"
    t.string "kobo"
    t.float "alcohol"
    t.float "aminosando"
    t.string "season"
    t.integer "warimizu", default: 0
    t.integer "moto", default: 0
    t.integer "seimai_buai"
    t.string "roka"
    t.string "shibori"
    t.text "note"
    t.integer "bottle_level", default: 0
    t.integer "hiire", default: 0
    t.integer "price"
    t.integer "size"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.boolean "admin", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

end
