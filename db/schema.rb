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

ActiveRecord::Schema.define(version: 2018_05_14_054343) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
    t.string "opening_id"
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
    t.string "upwork_client_id"
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

  create_table "v_tiger_crms", force: :cascade do |t|
    t.string "name"
    t.string "api_url"
    t.string "email"
    t.string "access_key"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "v_tiger_pipe_line_entities", force: :cascade do |t|
    t.string "vtiger_from_id"
    t.string "vtiger_to_id"
    t.string "kind"
    t.integer "state"
    t.bigint "crm_from_id"
    t.bigint "crm_to_id"
    t.json "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crm_from_id"], name: "index_v_tiger_pipe_line_entities_on_crm_from_id"
    t.index ["crm_to_id"], name: "index_v_tiger_pipe_line_entities_on_crm_to_id"
  end

end
