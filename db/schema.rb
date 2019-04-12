# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_04_12_195429) do

  create_table "keyword_ranks", force: :cascade do |t|
    t.integer "keyword_id"
    t.integer "position"
    t.date "valued_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["keyword_id"], name: "index_keyword_ranks_on_keyword_id"
    t.index ["position"], name: "index_keyword_ranks_on_position"
    t.index ["valued_at"], name: "index_keyword_ranks_on_valued_at"
  end

  create_table "keywords", force: :cascade do |t|
    t.string "department"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["department"], name: "index_keywords_on_department"
    t.index ["value", "department"], name: "index_keywords_on_value_and_department"
    t.index ["value"], name: "index_keywords_on_value"
  end

  create_table "product_performances", force: :cascade do |t|
    t.integer "keyword_id"
    t.integer "product_id"
    t.decimal "click_through_rate", precision: 5, scale: 2
    t.decimal "conversion_rate", precision: 5, scale: 2
    t.date "valued_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["keyword_id"], name: "index_product_performances_on_keyword_id"
    t.index ["product_id"], name: "index_product_performances_on_product_id"
    t.index ["valued_at"], name: "index_product_performances_on_valued_at"
  end

  create_table "products", force: :cascade do |t|
    t.string "asin"
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asin"], name: "index_products_on_asin"
  end

end
