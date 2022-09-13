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

ActiveRecord::Schema.define(version: 2022_09_13_132038) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "items", force: :cascade do |t|
    t.string "name"
    t.float "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "list_id", null: false
    t.index ["list_id"], name: "index_items_on_list_id"
    t.index ["name"], name: "index_items_on_name"
  end

  create_table "lists", force: :cascade do |t|
    t.string "name"
    t.float "budget", default: 0.0
    t.float "current_value", default: 0.0
    t.float "difference"
    t.boolean "exceeded", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "window_id", null: false
    t.bigint "user_id", null: false
    t.index ["name"], name: "index_lists_on_name"
    t.index ["user_id"], name: "index_lists_on_user_id"
    t.index ["window_id"], name: "index_lists_on_window_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "windows", force: :cascade do |t|
    t.string "name"
    t.float "budget", default: 0.0
    t.float "current_value", default: 0.0
    t.float "difference"
    t.boolean "exceeded", default: false
    t.date "start_date"
    t.date "end_date"
    t.integer "size"
    t.boolean "closed", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "user_id", null: false
    t.index ["closed"], name: "index_windows_on_closed"
    t.index ["name"], name: "index_windows_on_name"
    t.index ["size"], name: "index_windows_on_size"
    t.index ["start_date"], name: "index_windows_on_start_date"
    t.index ["user_id"], name: "index_windows_on_user_id"
  end

  create_table "windows_lists", id: false, force: :cascade do |t|
    t.bigint "tracker_id"
    t.bigint "tracked_list_id"
    t.index ["tracked_list_id"], name: "index_windows_lists_on_tracked_list_id"
    t.index ["tracker_id"], name: "index_windows_lists_on_tracker_id"
  end

  create_table "windows_windows", id: false, force: :cascade do |t|
    t.bigint "tracker_id"
    t.bigint "tracked_window_id"
    t.index ["tracked_window_id"], name: "index_windows_windows_on_tracked_window_id"
    t.index ["tracker_id"], name: "index_windows_windows_on_tracker_id"
  end

  add_foreign_key "items", "lists"
  add_foreign_key "lists", "users"
  add_foreign_key "lists", "windows"
  add_foreign_key "windows", "users"
end
