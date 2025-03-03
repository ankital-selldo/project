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

ActiveRecord::Schema[8.0].define(version: 2025_02_23_143855) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "clubs", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.string "club_name"
    t.string "club_logo"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["student_id"], name: "index_clubs_on_student_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "event_name"
    t.text "event_desc"
    t.string "event_image"
    t.string "event_venue"
    t.time "event_time"
    t.date "event_date"
    t.datetime "event_deadline"
    t.string "event_register_link", default: [], array: true
    t.bigint "club_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["club_id"], name: "index_events_on_club_id"
  end

  create_table "registers", force: :cascade do |t|
    t.string "name"
    t.string "branch"
    t.string "year"
    t.bigint "student_id", null: false
    t.bigint "event_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_registers_on_event_id"
    t.index ["student_id"], name: "index_registers_on_student_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.string "role", default: "user"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_students_on_email", unique: true
  end

  add_foreign_key "clubs", "students"
  add_foreign_key "events", "clubs"
  add_foreign_key "registers", "events"
  add_foreign_key "registers", "students"
end
