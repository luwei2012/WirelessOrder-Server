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

ActiveRecord::Schema.define(version: 20131024093519) do

  create_table "dish_menus", force: true do |t|
    t.integer  "menu_id"
    t.integer  "dish_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "amount"
    t.string   "remarks"
  end

  create_table "dish_styles", force: true do |t|
    t.string   "name"
    t.string   "describe"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dish_types", force: true do |t|
    t.string   "name"
    t.string   "describe"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "dishes", force: true do |t|
    t.string   "name"
    t.integer  "dish_type_id"
    t.integer  "price"
    t.integer  "dish_style_id"
    t.string   "remarks"
    t.integer  "status"
    t.integer  "count"
    t.string   "imageUrl"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "sales"
    t.integer  "cost_time"
  end

  create_table "menus", force: true do |t|
    t.integer  "table_id"
    t.float    "sales"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "price"
  end

  create_table "tables", force: true do |t|
    t.integer  "number"
    t.integer  "size"
    t.integer  "status"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "account"
    t.string   "password"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "role"
    t.string   "phone"
  end

end
