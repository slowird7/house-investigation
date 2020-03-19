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

ActiveRecord::Schema.define(version: 20191107125835) do

  create_table "choices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "damages", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "survey_type"
    t.integer  "position_wb",                   default: 0
    t.boolean  "genkyo",                        default: false
    t.boolean  "sukima",                        default: false
    t.boolean  "ware",                          default: false
    t.boolean  "kake",                          default: false
    t.boolean  "amimejyo",                      default: false
    t.boolean  "zencho",                        default: false
    t.boolean  "crack",                         default: false
    t.boolean  "tile",                          default: false
    t.boolean  "kire",                          default: false
    t.boolean  "uki",                           default: false
    t.boolean  "suhon",                         default: false
    t.boolean  "zenshu",                        default: false
    t.boolean  "chirigire",                     default: false
    t.boolean  "cross",                         default: false
    t.boolean  "meji",                          default: false
    t.boolean  "tategu",                        default: false
    t.boolean  "tasu",                          default: false
    t.boolean  "kakusyo",                       default: false
    t.float    "wide",               limit: 24, default: 0.0
    t.float    "length",             limit: 24, default: 0.0
    t.float    "width",              limit: 24, default: 0.0
    t.float    "height",             limit: 24, default: 0.0
    t.string   "comment"
    t.string   "image1"
    t.string   "image2"
    t.string   "image3"
    t.string   "image_url"
    t.string   "original_image_url"
    t.integer  "sonsyo_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.index ["sonsyo_id"], name: "index_damages_on_sonsyo_id", using: :btree
  end

  create_table "houses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "house_number"
    t.string   "house_name"
    t.string   "prefectures"
    t.string   "city"
    t.string   "block"
    t.string   "resident_phone_number"
    t.string   "owner_name_ruby"
    t.string   "owner_name"
    t.string   "owner_prefectures"
    t.string   "owner_city"
    t.string   "owner_block"
    t.string   "owner_phone_number"
    t.string   "construction"
    t.string   "floors"
    t.string   "area"
    t.string   "use"
    t.string   "sign_pre_survey"
    t.string   "sign_ongoing_survey"
    t.string   "sign_after_survey"
    t.string   "kyojyusya_sign_pre_survey"
    t.string   "kyojyusya_sign_ongoing_survey"
    t.string   "kyojyusya_sign_after_survey"
    t.string   "overview_pre_survey"
    t.string   "overview_ongoing_survey"
    t.string   "overview_after_survey"
    t.string   "range_pre_survey"
    t.string   "range_ongoing_survey"
    t.string   "range_after_survey"
    t.integer  "investigation_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.index ["investigation_id"], name: "index_houses_on_investigation_id", using: :btree
  end

  create_table "investigations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "content"
    t.string   "construction_name"
    t.string   "builder"
    t.string   "investigator_pre_survey"
    t.string   "investigator_ongoing_survey"
    t.string   "investigator_after_survey"
    t.string   "place"
    t.date     "start_pre_survey"
    t.date     "start_ongoing_survey"
    t.date     "start_after_survey"
    t.date     "stop_pre_survey"
    t.date     "stop_ongoing_survey"
    t.date     "stop_after_survey"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "keisyas", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "number"
    t.string   "room_name"
    t.string   "room_name_other"
    t.integer  "house_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["house_id"], name: "index_keisyas_on_house_id", using: :btree
  end

  create_table "points", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "number"
    t.string   "room_name"
    t.string   "room_name_other"
    t.integer  "house_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["house_id"], name: "index_points_on_house_id", using: :btree
  end

  create_table "posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "survey_type"
    t.integer  "position_wb",            default: 0
    t.float    "ouro_bs",     limit: 24, default: 0.0
    t.float    "ouro_fs",     limit: 24, default: 0.0
    t.float    "fukuro_bs",   limit: 24, default: 0.0
    t.float    "fukuro_fs",   limit: 24, default: 0.0
    t.float    "hyoko",       limit: 24, default: 0.0
    t.string   "comment"
    t.string   "image1"
    t.string   "image2"
    t.string   "image3"
    t.string   "image_url"
    t.integer  "point_id"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.index ["point_id"], name: "index_posts_on_point_id", using: :btree
  end

  create_table "slopes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "survey_type"
    t.integer  "position_wb",               default: 0
    t.boolean  "suichokukeisya",            default: false
    t.boolean  "suiheikeisya",              default: false
    t.float    "east",           limit: 24, default: 0.0
    t.float    "west",           limit: 24, default: 0.0
    t.float    "north",          limit: 24, default: 0.0
    t.float    "south",          limit: 24, default: 0.0
    t.string   "comment"
    t.string   "image1"
    t.string   "image2"
    t.string   "image3"
    t.string   "image_url"
    t.integer  "keisya_id"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.index ["keisya_id"], name: "index_slopes_on_keisya_id", using: :btree
  end

  create_table "sonsyos", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "number"
    t.string   "room_name"
    t.string   "room_name_other"
    t.integer  "house_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["house_id"], name: "index_sonsyos_on_house_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "role"
    t.string   "email"
    t.string   "user_name"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_foreign_key "damages", "sonsyos"
  add_foreign_key "houses", "investigations"
  add_foreign_key "keisyas", "houses"
  add_foreign_key "points", "houses"
  add_foreign_key "posts", "points"
  add_foreign_key "slopes", "keisyas"
  add_foreign_key "sonsyos", "houses"
end
