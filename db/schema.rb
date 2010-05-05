# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100505212020) do

  create_table "criterias", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_dates", :force => true do |t|
    t.integer "event_id"
    t.integer "day"
    t.date    "date"
    t.boolean "use_event_desc",  :default => true
    t.boolean "use_event_time",  :default => true
    t.boolean "use_event_price", :default => true
    t.integer "rating"
  end

  create_table "event_details", :force => true do |t|
    t.integer "info_id"
    t.string  "info_type"
    t.text    "desc"
    t.time    "time_from"
    t.time    "time_to"
    t.boolean "time_all_day"
    t.integer "price_at_door",         :limit => 10, :precision => 10, :scale => 0
    t.integer "price_advance",         :limit => 10, :precision => 10, :scale => 0
    t.date    "price_advance_expires"
    t.string  "purchase_url"
  end

  create_table "event_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events_types", :force => true do |t|
    t.integer "event_id"
    t.integer "event_type_id"
  end

  create_table "location_criteria_ratings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "locations_criteria_id"
    t.integer  "rating"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", :force => true do |t|
    t.string   "name"
    t.text     "full_address"
    t.string   "street_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country_code"
    t.string   "province"
    t.string   "lat"
    t.string   "lng"
    t.string   "phone"
    t.string   "website"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "status"
    t.string   "address_2"
  end

  create_table "locations_criterias", :force => true do |t|
    t.integer  "criteria_id"
    t.integer  "location_id"
    t.integer  "rating"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", :force => true do |t|
    t.text     "title"
    t.text     "content"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rates", :force => true do |t|
    t.integer  "rater_id"
    t.integer  "rateable_id"
    t.string   "rateable_type"
    t.integer  "stars",         :null => false
    t.string   "dimension"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rates", ["rateable_id", "rateable_type"], :name => "index_rates_on_rateable_id_and_rateable_type"
  add_index "rates", ["rater_id"], :name => "index_rates_on_rater_id"

  create_table "reviews", :force => true do |t|
    t.integer  "rating"
    t.text     "comment"
    t.integer  "location_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "reset_code"
    t.integer  "fb_user_id",                :limit => 8
    t.string   "email_hash"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
