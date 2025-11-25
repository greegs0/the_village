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

ActiveRecord::Schema[7.1].define(version: 2025_11_25_120001) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "chats", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_chats_on_user_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.date "date"
    t.string "place"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "max_participations"
    t.integer "participations_count"
    t.string "category"
    t.index ["user_id"], name: "index_events_on_user_id"
  end

  create_table "families", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "family_events", force: :cascade do |t|
    t.string "title"
    t.string "event_type"
    t.text "description"
    t.date "start_date"
    t.date "end_date"
    t.bigint "family_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.time "time"
    t.string "location"
    t.string "assigned_to"
    t.string "event_icon"
    t.string "badge_class"
    t.boolean "reminders_enabled", default: false
    t.index ["family_id"], name: "index_family_events_on_family_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "chat_id", null: false
    t.string "role", null: false
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id", "created_at"], name: "index_messages_on_chat_id_and_created_at"
    t.index ["chat_id"], name: "index_messages_on_chat_id"
  end

  create_table "people", force: :cascade do |t|
    t.string "name", null: false
    t.date "birthday"
    t.string "zipcode"
    t.bigint "family_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["family_id"], name: "index_people_on_family_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name"
    t.boolean "status"
    t.date "created_date"
    t.date "target_date"
    t.string "description"
    t.string "time"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "assignee_id"
    t.bigint "family_id", null: false
    t.index ["assignee_id"], name: "index_tasks_on_assignee_id"
    t.index ["family_id"], name: "index_tasks_on_family_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "status"
    t.bigint "family_id"
    t.string "zipcode"
    t.date "birthday"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["family_id"], name: "index_users_on_family_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "chats", "users"
  add_foreign_key "events", "users"
  add_foreign_key "family_events", "families"
  add_foreign_key "messages", "chats"
  add_foreign_key "people", "families"
  add_foreign_key "tasks", "families"
  add_foreign_key "tasks", "people", column: "assignee_id"
  add_foreign_key "tasks", "users"
  add_foreign_key "users", "families"
end
