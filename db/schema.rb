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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160504051022) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assessments", force: :cascade do |t|
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "booking_updates", force: :cascade do |t|
    t.integer  "booking_id"
    t.integer  "user_id"
    t.string   "from_status"
    t.string   "to_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bookings", force: :cascade do |t|
    t.string   "name"
    t.string   "location"
    t.integer  "days"
    t.date     "start_date"
    t.date     "end_date"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "vendor_id"
    t.string   "gen_type"
    t.integer  "client_id"
    t.string   "time_in"
    t.string   "time_out"
    t.string   "slip"
    t.string   "lisp"
    t.string   "kva"
    t.decimal  "cost"
    t.decimal  "actual_days"
    t.decimal  "actual_hours"
    t.integer  "rep_id"
    t.integer  "operator_id"
    t.string   "invoice_file_name"
    t.string   "invoice_content_type"
    t.integer  "invoice_file_size"
    t.datetime "invoice_updated_at"
    t.string   "assessment"
    t.string   "spoc_remarks"
    t.string   "owner_remarks"
    t.string   "invoice_status"
    t.string   "hours_status"
    t.string   "rep_phone_number"
  end

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "location"
    t.string   "balance"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.integer  "location_id"
  end

  create_table "groups", force: :cascade do |t|
    t.integer  "client_id"
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lisps", force: :cascade do |t|
    t.string   "state"
    t.string   "city"
    t.string   "zone"
    t.string   "name"
    t.string   "address"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lisps", ["code"], name: "index_lisps_on_code", using: :btree

  create_table "locations", force: :cascade do |t|
    t.string   "state"
    t.string   "city"
    t.string   "kv"
    t.integer  "fixed",        default: 0
    t.integer  "variable",     default: 0
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.decimal  "kva_30_day"
    t.decimal  "kva_30_hour"
    t.decimal  "kva_70_day"
    t.decimal  "kva_70_hour"
    t.decimal  "kva_130_day"
    t.decimal  "kva_130_hour"
    t.decimal  "kva_250_day"
    t.decimal  "kva_250_hour"
  end

  create_table "operators", force: :cascade do |t|
    t.string   "name"
    t.string   "phone_number"
    t.string   "email"
    t.integer  "vendor_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "rates", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "spoc_to_approver_mappings", force: :cascade do |t|
    t.integer  "spoc_id"
    t.integer  "approver1_id"
    t.integer  "approver2_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subgroups", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "client_id"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "location"
    t.string   "type"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "role_type"
    t.string   "state"
    t.string   "city"
    t.integer  "client_id"
    t.string   "employee_id"
    t.integer  "subgroup_id"
    t.string   "approver_type"
  end

end
