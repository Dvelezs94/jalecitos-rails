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

ActiveRecord::Schema.define(version: 2019_05_29_014224) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "ally_codes", force: :cascade do |t|
    t.string "token"
    t.integer "times_left", default: 1
    t.boolean "enabled", default: true
    t.string "name"
    t.boolean "level_enabled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "average_caches", force: :cascade do |t|
    t.bigint "rater_id"
    t.string "rateable_type"
    t.bigint "rateable_id"
    t.float "avg", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rateable_type", "rateable_id"], name: "index_average_caches_on_rateable_type_and_rateable_id"
    t.index ["rateable_type"], name: "index_average_caches_on_rateable_type"
    t.index ["rater_id", "rateable_id"], name: "index_average_caches_on_rater_id_and_rateable_id"
    t.index ["rater_id"], name: "index_average_caches_on_rater_id"
  end

  create_table "bans", force: :cascade do |t|
    t.integer "status", default: 0
    t.string "baneable_type"
    t.integer "baneable_id"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "cause"
  end

  create_table "billing_profiles", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "rfc"
    t.integer "zip_code"
    t.integer "status", default: 0
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_billing_profiles_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "icon"
  end

  create_table "cities", force: :cascade do |t|
    t.string "name"
    t.bigint "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_cities_on_state_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "sender_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["recipient_id", "sender_id"], name: "index_conversations_on_recipient_id_and_sender_id", unique: true
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
    t.bigint "state_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["state_id"], name: "index_countries_on_state_id"
  end

  create_table "disputes", force: :cascade do |t|
    t.bigint "order_id"
    t.integer "status", default: 0
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "images"
    t.index ["order_id"], name: "index_disputes_on_order_id"
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

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "gigs", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "location"
    t.integer "order_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "category_id"
    t.integer "status", default: 0
    t.string "slug"
    t.json "images"
    t.float "score_average", default: 0.0
    t.integer "score_times", default: 0
    t.string "profession"
    t.bigint "city_id"
    t.string "youtube_url"
    t.integer "visits", default: 0
    t.index ["category_id"], name: "index_gigs_on_category_id"
    t.index ["city_id"], name: "index_gigs_on_city_id"
    t.index ["slug"], name: "index_gigs_on_slug", unique: true
    t.index ["user_id"], name: "index_gigs_on_user_id"
  end

  create_table "likes", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "gig_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gig_id"], name: "index_likes_on_gig_id"
    t.index ["user_id"], name: "index_likes_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id"
    t.bigint "conversation_id"
    t.datetime "read_at"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "related_to_id"
    t.string "related_to_type"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.bigint "user_id"
    t.integer "recipient_id"
    t.string "action"
    t.string "notifiable_type"
    t.integer "notifiable_id"
    t.string "query_url"
    t.datetime "read_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "offers", force: :cascade do |t|
    t.bigint "user_id"
    t.string "description"
    t.float "price"
    t.bigint "request_id"
    t.integer "hours"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "materials", default: true
    t.index ["request_id"], name: "index_offers_on_request_id"
    t.index ["user_id"], name: "index_offers_on_user_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "employer_id"
    t.float "total"
    t.integer "card_id"
    t.string "purchase_type"
    t.integer "purchase_id"
    t.integer "status", default: 0
    t.string "payment_message"
    t.string "response_order_id"
    t.integer "employee_id"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.string "paid_at"
    t.string "uuid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "payout_id"
    t.bigint "billing_profile_id"
    t.integer "invoice_status"
    t.string "invoice_id"
    t.string "response_refund_id"
    t.string "response_completion_id"
    t.string "response_fee_id"
    t.string "response_tax_id"
    t.string "response_openpay_tax_id"
    t.string "address"
    t.string "details"
    t.float "payout_left"
    t.string "unit_type"
    t.integer "unit_count"
    t.index ["billing_profile_id"], name: "index_orders_on_billing_profile_id"
    t.index ["employer_id", "employee_id"], name: "index_orders_on_employer_id_and_employee_id"
    t.index ["payout_id"], name: "index_orders_on_payout_id"
  end

  create_table "overall_averages", force: :cascade do |t|
    t.string "rateable_type"
    t.bigint "rateable_id"
    t.float "overall_avg", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rateable_id", "rateable_type"], name: "index_overall_averages_on_rateable_id_and_rateable_type"
    t.index ["rateable_type", "rateable_id"], name: "index_overall_averages_on_rateable_type_and_rateable_id"
  end

  create_table "packages", force: :cascade do |t|
    t.integer "pack_type"
    t.string "name"
    t.string "description"
    t.float "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "gig_id"
    t.string "slug"
    t.integer "max_amount"
    t.integer "min_amount"
    t.integer "unit_type"
    t.index ["gig_id"], name: "index_packages_on_gig_id"
    t.index ["slug"], name: "index_packages_on_slug", unique: true
  end

  create_table "payments", force: :cascade do |t|
    t.float "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "package_id"
    t.bigint "offer_id"
    t.index ["offer_id"], name: "index_payments_on_offer_id"
    t.index ["package_id"], name: "index_payments_on_package_id"
    t.index ["user_id"], name: "index_payments_on_user_id"
  end

  create_table "payouts", force: :cascade do |t|
    t.string "transaction_id"
    t.bigint "user_id"
    t.integer "status", default: 0
    t.string "bank_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "level"
    t.index ["user_id"], name: "index_payouts_on_user_id"
  end

  create_table "professions", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "push_subscriptions", force: :cascade do |t|
    t.bigint "user_id"
    t.string "auth_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_push_subscriptions_on_user_id"
  end

  create_table "rates", force: :cascade do |t|
    t.bigint "rater_id"
    t.string "rateable_type"
    t.bigint "rateable_id"
    t.float "stars", null: false
    t.string "dimension"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rateable_id", "rateable_type"], name: "index_rates_on_rateable_id_and_rateable_type"
    t.index ["rateable_type", "rateable_id"], name: "index_rates_on_rateable_type_and_rateable_id"
    t.index ["rater_id"], name: "index_rates_on_rater_id"
  end

  create_table "rating_caches", force: :cascade do |t|
    t.string "cacheable_type"
    t.bigint "cacheable_id"
    t.float "avg", null: false
    t.integer "qty", null: false
    t.string "dimension"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cacheable_id", "cacheable_type"], name: "index_rating_caches_on_cacheable_id_and_cacheable_type"
    t.index ["cacheable_type", "cacheable_id"], name: "index_rating_caches_on_cacheable_type_and_cacheable_id"
  end

  create_table "replies", force: :cascade do |t|
    t.bigint "dispute_id"
    t.string "message"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dispute_id"], name: "index_replies_on_dispute_id"
    t.index ["user_id"], name: "index_replies_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.bigint "user_id"
    t.string "reportable_type"
    t.integer "reportable_id"
    t.integer "status", default: 0
    t.string "cause_str"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ban_id"
    t.integer "cause"
    t.index ["ban_id"], name: "index_reports_on_ban_id"
    t.index ["user_id"], name: "index_reports_on_user_id"
  end

  create_table "requests", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "description"
    t.bigint "category_id"
    t.string "budget"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.integer "employee_id"
    t.string "profession"
    t.bigint "city_id"
    t.integer "offers_count", default: 0
    t.json "images"
    t.index ["category_id"], name: "index_requests_on_category_id"
    t.index ["city_id"], name: "index_requests_on_city_id"
    t.index ["slug"], name: "index_requests_on_slug", unique: true
    t.index ["user_id"], name: "index_requests_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.string "comment"
    t.integer "giver_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_id"
    t.integer "status", default: 0
    t.integer "reviewable_id"
    t.string "reviewable_type"
    t.integer "receiver_id"
    t.index ["giver_id"], name: "index_reviews_on_giver_id"
    t.index ["order_id"], name: "index_reviews_on_order_id"
  end

  create_table "states", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "country_id"
    t.index ["country_id"], name: "index_states_on_country_id"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "ticket_responses", force: :cascade do |t|
    t.bigint "ticket_id"
    t.bigint "user_id"
    t.string "message"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_ticket_responses_on_ticket_id"
    t.index ["user_id"], name: "index_ticket_responses_on_user_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.string "title"
    t.string "description"
    t.integer "priority"
    t.bigint "user_id"
    t.integer "status", default: 0
    t.string "image"
    t.integer "turn", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.json "images"
    t.index ["slug"], name: "index_tickets_on_slug", unique: true
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "user_scores", force: :cascade do |t|
    t.float "employer_score_average", default: 0.0
    t.float "employee_score_average", default: 0.0
    t.integer "employer_score_times", default: 0
    t.integer "employee_score_times", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "level", default: 1
    t.float "total_sales", default: 0.0
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "score_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "roles"
    t.string "alias"
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.text "image"
    t.string "slug"
    t.string "bio"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "openpay_id"
    t.integer "status", default: 0
    t.integer "age"
    t.string "available"
    t.boolean "transactional_emails", default: true
    t.boolean "marketing_emails", default: true
    t.boolean "verified", default: false
    t.bigint "city_id"
    t.string "time_zone", default: "America/Mexico_City"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.bigint "ally_code_id"
    t.boolean "secure_transaction", default: false
    t.string "secure_transaction_job_id"
    t.index ["ally_code_id"], name: "index_users_on_ally_code_id"
    t.index ["city_id"], name: "index_users_on_city_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["score_id"], name: "index_users_on_score_id"
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "verifications", force: :cascade do |t|
    t.bigint "user_id"
    t.json "identification"
    t.string "curp"
    t.string "address"
    t.string "criminal_letter"
    t.integer "status", default: 0
    t.string "denial_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_verifications_on_user_id"
  end

  add_foreign_key "billing_profiles", "users"
  add_foreign_key "cities", "states"
  add_foreign_key "countries", "states"
  add_foreign_key "disputes", "orders"
  add_foreign_key "extras", "gigs", column: "gigs_id"
  add_foreign_key "gigs", "categories"
  add_foreign_key "gigs", "cities"
  add_foreign_key "gigs", "users"
  add_foreign_key "likes", "gigs"
  add_foreign_key "likes", "users"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "users"
  add_foreign_key "notifications", "users"
  add_foreign_key "offers", "requests"
  add_foreign_key "offers", "users"
  add_foreign_key "orders", "billing_profiles"
  add_foreign_key "orders", "payouts"
  add_foreign_key "packages", "gigs"
  add_foreign_key "payments", "offers"
  add_foreign_key "payments", "packages"
  add_foreign_key "payments", "users"
  add_foreign_key "payouts", "users"
  add_foreign_key "push_subscriptions", "users"
  add_foreign_key "replies", "disputes"
  add_foreign_key "replies", "users"
  add_foreign_key "reports", "bans"
  add_foreign_key "reports", "users"
  add_foreign_key "requests", "categories"
  add_foreign_key "requests", "cities"
  add_foreign_key "requests", "users"
  add_foreign_key "reviews", "orders"
  add_foreign_key "states", "countries"
  add_foreign_key "ticket_responses", "tickets"
  add_foreign_key "ticket_responses", "users"
  add_foreign_key "tickets", "users"
  add_foreign_key "users", "ally_codes"
  add_foreign_key "users", "cities"
  add_foreign_key "verifications", "users"
end
