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

ActiveRecord::Schema.define(version: 2019_09_22_232247) do

  create_table "events", force: :cascade do |t|
    t.string "event_type", default: "game"
    t.integer "home_team_id"
    t.integer "away_team_id"
    t.integer "home_score", default: 0
    t.integer "away_score", default: 0
    t.string "location_name"
    t.string "location_address"
    t.string "location_detail"
    t.datetime "start_at"
    t.datetime "started_at"
    t.datetime "ended_at"
  end

  create_table "team_members", force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
    t.string "role", default: "player"
    t.string "jersey_number"
    t.index ["user_id", "team_id"], name: "index_team_members_on_user_id_and_team_id", unique: true
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.integer "team_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "wins", default: 0
    t.integer "losses", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
