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

ActiveRecord::Schema.define(version: 2018_10_09_013553) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "extras", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "gigs_id"
    t.index ["gigs_id"], name: "index_extras_on_gigs_id"
  end

  create_table "gigs", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "image"
    t.string "location"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "category_id"
    t.bigint "tag_id"
    t.integer "status", default: 0
    t.index ["category_id"], name: "index_gigs_on_category_id"
    t.index ["tag_id"], name: "index_gigs_on_tag_id"
    t.index ["user_id"], name: "index_gigs_on_user_id"
  end

  create_table "gigs_tags", id: false, force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "gig_id", null: false
  end

  create_table "packages", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.float "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "package_id"
    t.index ["package_id"], name: "index_payments_on_package_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.float "stars"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "gigs_id"
    t.index ["gigs_id"], name: "index_reviews_on_gigs_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.float "employee_stars"
    t.float "employer_stars"
    t.string "roles"
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.text "image"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "extras", "gigs", column: "gigs_id"
  add_foreign_key "gigs", "categories"
  add_foreign_key "gigs", "tags"
  add_foreign_key "gigs", "users"
  add_foreign_key "payments", "packages"
  add_foreign_key "payments", "users"
  add_foreign_key "reviews", "gigs", column: "gigs_id"
end
