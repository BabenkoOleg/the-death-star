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

ActiveRecord::Schema.define(version: 2018_05_25_061730) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_users", force: :cascade do |t|
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
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "upwork_categories", force: :cascade do |t|
    t.string "title"
    t.string "upwork_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "upwork_clients", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "url"
    t.string "city"
    t.string "country"
    t.string "state"
    t.string "world_region"
    t.string "opening_uid"
    t.string "upwork_id", null: false
    t.string "vtiger_id"
    t.string "vtiger_state", default: "0"
    t.integer "active_assignments_count"
    t.integer "feedback_count"
    t.integer "hours_count"
    t.integer "total_assignments"
    t.integer "total_charges"
    t.integer "total_jobs_with_hires"
    t.integer "filled_count"
    t.integer "open_count"
    t.integer "posted_count"
    t.float "score"
    t.float "avg_hourly_jobs_rate"
    t.boolean "is_payment_method_verified"
    t.datetime "contract_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "upwork_jobs", force: :cascade do |t|
    t.string "title"
    t.string "status"
    t.string "pricing"
    t.string "duration"
    t.string "workload"
    t.string "opening_uid"
    t.string "description"
    t.string "url", null: false
    t.string "upwork_id", null: false
    t.string "parsing_error_description"
    t.integer "slack_state", default: 0
    t.integer "parsing_state", default: 0
    t.float "budget"
    t.datetime "created_date"
    t.bigint "client_id"
    t.bigint "category_id"
    t.bigint "subcategory_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_upwork_jobs_on_category_id"
    t.index ["client_id"], name: "index_upwork_jobs_on_client_id"
    t.index ["subcategory_id"], name: "index_upwork_jobs_on_subcategory_id"
  end

  create_table "upwork_jobs_skills", id: false, force: :cascade do |t|
    t.bigint "job_id"
    t.bigint "skill_id"
    t.index ["job_id"], name: "index_upwork_jobs_skills_on_job_id"
    t.index ["skill_id"], name: "index_upwork_jobs_skills_on_skill_id"
  end

  create_table "upwork_proxies", force: :cascade do |t|
    t.string "host"
    t.integer "port"
    t.integer "state", default: 0
    t.boolean "busy", default: false
    t.datetime "last_request_at"
    t.boolean "got_recaptcha", default: false
    t.datetime "got_recaptcha_at"
  end

  create_table "upwork_search_queries", force: :cascade do |t|
    t.string "q"
    t.string "title"
    t.string "cache_category"
    t.integer "page", default: 0
    t.boolean "came_to_end", default: false
    t.bigint "category_id"
    t.bigint "subcategory_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_upwork_search_queries_on_category_id"
    t.index ["subcategory_id"], name: "index_upwork_search_queries_on_subcategory_id"
  end

  create_table "upwork_search_queries_skills", force: :cascade do |t|
    t.bigint "search_query_id"
    t.bigint "skill_id"
    t.index ["search_query_id"], name: "index_upwork_search_queries_skills_on_search_query_id"
    t.index ["skill_id"], name: "index_upwork_search_queries_skills_on_skill_id"
  end

  create_table "upwork_skills", force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "upwork_subcategories", force: :cascade do |t|
    t.string "title"
    t.string "upwork_id"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_upwork_subcategories_on_category_id"
  end

  create_table "upwork_users", force: :cascade do |t|
    t.string "email"
    t.string "password"
    t.string "user_agent"
    t.string "sidekiq_jid"
    t.integer "waiting_time", default: 1
    t.boolean "locked", default: false
    t.boolean "boolean", default: false
    t.datetime "last_request_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
