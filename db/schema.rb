# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111112002849) do

  create_table "friends", :force => true do |t|
    t.integer  "inviter_id"
    t.integer  "invitee_id"
    t.boolean  "confirmed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "small_id"
    t.integer  "big_id"
  end

  add_index "friends", ["small_id", "big_id"], :name => "by_small_and_big", :unique => true

  create_table "locations", :force => true do |t|
    t.decimal  "lng",             :precision => 15, :scale => 10
    t.decimal  "lat",             :precision => 15, :scale => 10
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "Source_plus_UID"
  end

  create_table "profiles", :force => true do |t|
    t.integer  "user_id"
    t.integer  "age"
    t.string   "image_url"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "gender"
    t.string   "username"
    t.decimal  "lat",         :precision => 15, :scale => 10
    t.decimal  "lng",         :precision => 15, :scale => 10
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "usertype"
  end

  create_table "zombie_sightings", :force => true do |t|
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
