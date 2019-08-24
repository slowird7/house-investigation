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

ActiveRecord::Schema.define(version: 20190822085653) do

  create_table "choices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "houses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "house_name"
    t.string   "prefectures"
    t.string   "city"
    t.string   "block"
    t.string   "resident_phone_number"
    t.string   "owner_name"
    t.string   "owner_prefectures"
    t.string   "owner_city"
    t.string   "owner_block"
    t.string   "owner_phone_number"
    t.string   "construction"
    t.string   "floors"
    t.string   "area"
    t.string   "use"
    t.integer  "investigation_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.index ["investigation_id"], name: "index_houses_on_investigation_id", using: :btree
  end

  create_table "investigations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "content"
    t.string   "construction_name"
    t.string   "builder"
    t.string   "investigator"
    t.string   "place"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "points", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.boolean  "genkyo",         default: false
    t.boolean  "sukima",         default: false
    t.boolean  "ware",           default: false
    t.boolean  "kake",           default: false
    t.boolean  "amimejyo",       default: false
    t.boolean  "zencho",         default: false
    t.boolean  "sokuten",        default: false
    t.boolean  "crack",          default: false
    t.boolean  "tile",           default: false
    t.boolean  "kire",           default: false
    t.boolean  "uki",            default: false
    t.boolean  "suhon",          default: false
    t.boolean  "zenshu",         default: false
    t.boolean  "suichokukeisya", default: false
    t.boolean  "chirigire",      default: false
    t.boolean  "cross",          default: false
    t.boolean  "meji",           default: false
    t.boolean  "tategu",         default: false
    t.boolean  "tasu",           default: false
    t.boolean  "kakusyo",        default: false
    t.boolean  "suiheikeisya",   default: false
    t.integer  "wide"
    t.integer  "height"
    t.integer  "length"
    t.string   "comment"
    t.string   "image1"
    t.string   "image2"
    t.string   "image3"
    t.integer  "survey_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["survey_id"], name: "index_points_on_survey_id", using: :btree
  end

  create_table "surveys", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "survey_name"
    t.string   "overview"
    t.string   "range"
    t.integer  "house_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["house_id"], name: "index_surveys_on_house_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "role"
    t.string   "email"
    t.string   "user_name"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "houses", "investigations"
  add_foreign_key "points", "surveys"
  add_foreign_key "surveys", "houses"
end
