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

ActiveRecord::Schema.define(version: 2020_06_24_040927) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "boards", force: :cascade do |t|
    t.string "name"
    t.boolean "closed", default: false
    t.string "color", default: "blue"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "starred", default: false
    t.index ["user_id"], name: "index_boards_on_user_id"
  end

  create_table "cards", force: :cascade do |t|
    t.string "name"
    t.text "desc"
    t.integer "pos"
    t.boolean "closed", default: false
    t.bigint "list_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["list_id"], name: "index_cards_on_list_id"
  end

  create_table "cards_labels", id: false, force: :cascade do |t|
    t.bigint "card_id", null: false
    t.bigint "label_id", null: false
  end

  create_table "check_items", force: :cascade do |t|
    t.string "name"
    t.integer "pos", default: 1
    t.boolean "completed", default: false
    t.bigint "checklist_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["checklist_id"], name: "index_check_items_on_checklist_id"
  end

  create_table "checklists", force: :cascade do |t|
    t.string "name"
    t.integer "pos", default: 1
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "card_id", null: false
    t.index ["card_id"], name: "index_checklists_on_card_id"
  end

  create_table "labels", force: :cascade do |t|
    t.string "name"
    t.string "color", default: "blue"
    t.bigint "board_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["board_id"], name: "index_labels_on_board_id"
  end

  create_table "lists", force: :cascade do |t|
    t.string "name"
    t.integer "pos", default: 1
    t.boolean "closed", default: false
    t.bigint "board_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["board_id"], name: "index_lists_on_board_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "password_digest"
    t.string "token"
    t.index ["token"], name: "index_users_on_token"
  end

  add_foreign_key "boards", "users"
  add_foreign_key "cards", "lists"
  add_foreign_key "check_items", "checklists"
  add_foreign_key "checklists", "cards"
  add_foreign_key "labels", "boards"
  add_foreign_key "lists", "boards"
end
