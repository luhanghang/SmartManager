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

ActiveRecord::Schema.define(:version => 20101115075702) do

  create_table "companies", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "companies_gateways", :id => false, :force => true do |t|
    t.integer "gateway_id"
    t.integer "company_id"
    t.integer "capacity",    :default => 0
    t.integer "concurrency", :default => 0
  end

  create_table "encoders", :force => true do |t|
    t.integer  "seq"
    t.string   "name"
    t.string   "address"
    t.integer  "service_port"
    t.string   "ptz_protocal"
    t.integer  "audio_port"
    t.integer  "io_addr"
    t.integer  "connect_type"
    t.integer  "device"
    t.integer  "gateway_id",   :default => 0
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "gateways", :force => true do |t|
    t.integer  "seq"
    t.string   "name"
    t.string   "address"
    t.integer  "port"
    t.integer  "web_port"
    t.string   "apptype"
    t.string   "driver"
    t.string   "protocal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "login_users", :force => true do |t|
    t.integer  "user_id"
    t.string   "session_id"
    t.datetime "logintime"
    t.datetime "lasttime"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "logs", :force => true do |t|
    t.integer  "user_id"
    t.string   "account"
    t.integer  "company_id"
    t.string   "user_name"
    t.string   "operation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "map_spots", :id => false, :force => true do |t|
    t.integer "spot_id"
    t.integer "map_id"
    t.decimal "x",       :precision => 11, :scale => 5
    t.decimal "y",       :precision => 11, :scale => 5
  end

  create_table "maps", :force => true do |t|
    t.string   "name"
    t.integer  "parent_id",  :default => 0
    t.integer  "web",        :default => 0
    t.string   "city"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "polling_scheme_items", :force => true do |t|
    t.integer  "polling_scheme_id"
    t.integer  "item_type"
    t.integer  "spot_id"
    t.integer  "spot_presetting_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "polling_schemes", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.integer  "interval"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "privileges", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "privileges_roles", :id => false, :force => true do |t|
    t.integer "privilege_id"
    t.integer "role_id"
  end

  create_table "privileges_user_groups", :id => false, :force => true do |t|
    t.integer "privilege_id"
    t.integer "user_group_id"
  end

  create_table "record_schedule_dailies", :force => true do |t|
    t.integer  "spot_id"
    t.integer  "start_hour"
    t.integer  "start_min"
    t.integer  "end_hour"
    t.integer  "end_min"
    t.integer  "last_time"
    t.date     "schedule_date"
    t.integer  "enabled"
    t.integer  "color",         :default => -1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "record_schedules", :force => true do |t|
    t.integer  "spot_id"
    t.integer  "start_hour"
    t.integer  "start_min"
    t.integer  "end_hour"
    t.integer  "end_min"
    t.integer  "last_time"
    t.integer  "week_day"
    t.integer  "enabled"
    t.integer  "color",      :default => -1
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.string   "alias"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "spot_gps_records", :id => false, :force => true do |t|
    t.integer  "spot_id"
    t.integer  "map_id"
    t.integer  "x"
    t.integer  "y"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spot_groups", :force => true do |t|
    t.string  "name"
    t.string  "alias"
    t.integer "parent_id",  :default => 1
    t.integer "company_id"
  end

  create_table "spot_presettings", :force => true do |t|
    t.integer  "spot_id"
    t.integer  "position"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spot_states", :force => true do |t|
    t.integer "gateway_id"
    t.string  "spot"
  end

  create_table "spots", :force => true do |t|
    t.integer  "seq"
    t.string   "name"
    t.string   "alias"
    t.string   "global_id"
    t.integer  "encoder_id"
    t.integer  "spot_group_id",   :default => 1
    t.integer  "v_encode_type"
    t.integer  "v_channel"
    t.integer  "v_com_method"
    t.integer  "v_src_port"
    t.integer  "v_protocal_type"
    t.integer  "v_encode_rate"
    t.integer  "v_resolution"
    t.integer  "a_encode_type"
    t.integer  "a_channel"
    t.integer  "a_com_method"
    t.integer  "a_src_port"
    t.integer  "a_protocal_type"
    t.integer  "a_encode_rate"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "spots_user_groups", :id => false, :force => true do |t|
    t.integer "spot_id"
    t.integer "user_group_id"
  end

  create_table "user_groups", :force => true do |t|
    t.string   "name"
    t.integer  "role_id"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "account"
    t.string   "passwd"
    t.string   "realname"
    t.integer  "user_group_id", :default => 0
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
