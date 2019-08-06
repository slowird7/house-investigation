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

ActiveRecord::Schema.define(version: 20190718141956) do

  create_table "choices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "houses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "house_name"
    t.string   "phone_number"
    t.string   "post_code"
    t.string   "prefectures"
    t.string   "city"
    t.string   "block"
    t.string   "owner"
    t.integer  "investigation_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
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

  create_table "surveys", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "type"
    t.integer  "house_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["house_id"], name: "index_surveys_on_house_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "role"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "houses", "investigations"
  add_foreign_key "surveys", "houses"
end
