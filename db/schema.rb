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

ActiveRecord::Schema.define(version: 20150922092640) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "areas", force: :cascade do |t|
    t.string   "name",        limit: 255, null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hoshin_id",               null: false
    t.integer  "position"
    t.integer  "company_id",              null: false
    t.integer  "creator_id"
    t.string   "color",       limit: 255
    t.datetime "deleted_at"
  end

  add_index "areas", ["company_id"], name: "index_areas_on_company_id", using: :btree
  add_index "areas", ["creator_id"], name: "index_areas_on_creator_id", using: :btree
  add_index "areas", ["deleted_at"], name: "index_areas_on_deleted_at", using: :btree
  add_index "areas", ["hoshin_id"], name: "index_areas_on_hoshin_id", using: :btree

  create_table "auth_providers", force: :cascade do |t|
    t.string   "email_domain", limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type",         limit: 255
    t.string   "openid_url",   limit: 255
    t.string   "issuer",       limit: 255
    t.string   "sso_url",      limit: 255
    t.text     "cert"
    t.string   "fingerprint",  limit: 255
    t.string   "id_format",    limit: 255
  end

  add_index "auth_providers", ["email_domain", "type"], name: "index_auth_providers_on_email_domain_and_type", unique: true, using: :btree
  add_index "auth_providers", ["type"], name: "index_auth_providers_on_type", using: :btree

  create_table "authorizations", force: :cascade do |t|
    t.string   "provider",      limit: 255, null: false
    t.string   "uid",           limit: 255, null: false
    t.string   "email_address", limit: 255
    t.string   "name",          limit: 255
    t.string   "nickname",      limit: 255
    t.string   "location",      limit: 255
    t.string   "image",         limit: 255
    t.text     "description"
    t.string   "phone",         limit: 255
    t.text     "urls"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "authorizations", ["email_address"], name: "index_authorizations_on_email_address", using: :btree
  add_index "authorizations", ["provider"], name: "index_authorizations_on_provider", using: :btree
  add_index "authorizations", ["uid"], name: "index_authorizations_on_uid", using: :btree
  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id", using: :btree

  create_table "billing_plans", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "description",     limit: 255
    t.text     "features"
    t.string   "frequency",       limit: 255
    t.integer  "interval"
    t.string   "amount_currency", limit: 255
    t.decimal  "amount_value",                precision: 8, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "id_paypal",       limit: 255
    t.string   "status_paypal",   limit: 255
    t.string   "brief",           limit: 255
    t.string   "css_class",       limit: 255
    t.integer  "position"
    t.integer  "users"
    t.integer  "workers"
  end

  create_table "client_applications", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.string   "key",         limit: 255
    t.string   "secret",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.datetime "deleted_at"
  end

  add_index "client_applications", ["deleted_at"], name: "index_client_applications_on_deleted_at", using: :btree
  add_index "client_applications", ["user_id"], name: "index_client_applications_on_user_id", using: :btree

  create_table "companies", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.integer  "hoshins_count",             default: 0,     null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "creator_id"
    t.boolean  "unlimited",                 default: false, null: false
    t.datetime "deleted_at"
  end

  add_index "companies", ["creator_id"], name: "index_companies_on_creator_id", using: :btree
  add_index "companies", ["deleted_at"], name: "index_companies_on_deleted_at", using: :btree

  create_table "company_email_domains", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "domain"
    t.integer  "company_id"
  end

  add_index "company_email_domains", ["company_id"], name: "index_company_email_domains_on_company_id", using: :btree
  add_index "company_email_domains", ["domain", "company_id"], name: "index_company_email_domains_on_domain_and_company_id", using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",               default: 0, null: false
    t.integer  "attempts",               default: 0, null: false
    t.text     "handler",                            null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "goals", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "hoshin_id",              null: false
    t.integer  "company_id",             null: false
    t.integer  "position"
    t.integer  "creator_id"
    t.datetime "deleted_at"
  end

  add_index "goals", ["company_id"], name: "index_goals_on_company_id", using: :btree
  add_index "goals", ["creator_id"], name: "index_goals_on_creator_id", using: :btree
  add_index "goals", ["deleted_at"], name: "index_goals_on_deleted_at", using: :btree
  add_index "goals", ["hoshin_id"], name: "index_goals_on_hoshin_id", using: :btree

  create_table "hoshins", force: :cascade do |t|
    t.string   "name",                       limit: 255, default: "plan",   null: false
    t.integer  "areas_count",                            default: 0,        null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id"
    t.integer  "parent_id"
    t.text     "header"
    t.integer  "creator_id"
    t.integer  "objectives_count",                       default: 0,        null: false
    t.integer  "goals_count",                            default: 0,        null: false
    t.integer  "indicators_count",                       default: 0,        null: false
    t.integer  "tasks_count",                            default: 0,        null: false
    t.integer  "outdated_indicators_count",              default: 0,        null: false
    t.integer  "outdated_tasks_count",                   default: 0,        null: false
    t.integer  "blind_objectives_count",                 default: 0,        null: false
    t.integer  "neglected_objectives_count",             default: 0,        null: false
    t.integer  "hoshins_count",                          default: 0,        null: false
    t.datetime "health_updated_at"
    t.string   "state",                      limit: 255, default: "active"
    t.datetime "key_timestamp"
    t.datetime "deleted_at"
    t.string   "color",                      limit: 255
  end

  add_index "hoshins", ["company_id", "parent_id"], name: "index_hoshins_on_company_id_and_parent_id", using: :btree
  add_index "hoshins", ["company_id"], name: "index_hoshins_on_company_id", using: :btree
  add_index "hoshins", ["creator_id"], name: "index_hoshins_on_creator_id", using: :btree
  add_index "hoshins", ["deleted_at"], name: "index_hoshins_on_deleted_at", using: :btree
  add_index "hoshins", ["parent_id"], name: "index_hoshins_on_parent_id", using: :btree
  add_index "hoshins", ["state"], name: "index_hoshins_on_state", using: :btree

  create_table "indicator_histories", force: :cascade do |t|
    t.decimal  "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "indicator_id",   null: false
    t.date     "day"
    t.decimal  "goal"
    t.integer  "creator_id"
    t.integer  "company_id",     null: false
    t.integer  "responsible_id"
    t.decimal  "previous"
  end

  add_index "indicator_histories", ["company_id"], name: "index_indicator_histories_on_company_id", using: :btree
  add_index "indicator_histories", ["creator_id"], name: "index_indicator_histories_on_creator_id", using: :btree
  add_index "indicator_histories", ["indicator_id", "day"], name: "index_indicator_histories_on_indicator_id_and_day", unique: true, using: :btree
  add_index "indicator_histories", ["indicator_id"], name: "index_indicator_histories_on_indicator_id", using: :btree
  add_index "indicator_histories", ["responsible_id"], name: "index_indicator_histories_on_responsible_id", using: :btree

  create_table "indicators", force: :cascade do |t|
    t.string   "name",                limit: 255,                 null: false
    t.decimal  "value"
    t.text     "description"
    t.string   "frequency",           limit: 255
    t.date     "next_update"
    t.decimal  "goal",                            default: 100.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "objective_id",                                    null: false
    t.integer  "area_id",                                         null: false
    t.integer  "ind_pos"
    t.date     "last_update"
    t.decimal  "last_value"
    t.integer  "responsible_id"
    t.integer  "company_id",                                      null: false
    t.boolean  "reminder",                        default: true,  null: false
    t.decimal  "worst_value",                     default: 0.0
    t.boolean  "show_on_parent",                  default: false, null: false
    t.string   "type",                limit: 255
    t.integer  "creator_id"
    t.integer  "hoshin_id",                                       null: false
    t.boolean  "show_on_charts",                  default: true,  null: false
    t.integer  "parent_area_id"
    t.integer  "parent_objective_id"
    t.datetime "deleted_at"
  end

  add_index "indicators", ["area_id"], name: "index_indicators_on_area_id", using: :btree
  add_index "indicators", ["company_id"], name: "index_indicators_on_company_id", using: :btree
  add_index "indicators", ["creator_id"], name: "index_indicators_on_creator_id", using: :btree
  add_index "indicators", ["deleted_at"], name: "index_indicators_on_deleted_at", using: :btree
  add_index "indicators", ["hoshin_id"], name: "index_indicators_on_hoshin_id", using: :btree
  add_index "indicators", ["objective_id"], name: "index_indicators_on_objective_id", using: :btree
  add_index "indicators", ["parent_area_id"], name: "index_indicators_on_parent_area_id", using: :btree
  add_index "indicators", ["parent_objective_id"], name: "index_indicators_on_parent_objective_id", using: :btree
  add_index "indicators", ["responsible_id"], name: "index_indicators_on_responsible_id", using: :btree
  add_index "indicators", ["type"], name: "index_indicators_on_type", using: :btree

  create_table "logs", force: :cascade do |t|
    t.string   "title",        limit: 255
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "company_id",               null: false
    t.integer  "creator_id"
    t.integer  "hoshin_id"
    t.integer  "area_id"
    t.integer  "goal_id"
    t.integer  "objective_id"
    t.integer  "indicator_id"
    t.string   "type",         limit: 255
    t.integer  "task_id"
    t.string   "operation",    limit: 255, null: false
  end

  add_index "logs", ["area_id"], name: "index_logs_on_area_id", using: :btree
  add_index "logs", ["company_id"], name: "index_logs_on_company_id", using: :btree
  add_index "logs", ["creator_id"], name: "index_logs_on_creator_id", using: :btree
  add_index "logs", ["goal_id"], name: "index_logs_on_goal_id", using: :btree
  add_index "logs", ["hoshin_id"], name: "index_logs_on_hoshin_id", using: :btree
  add_index "logs", ["indicator_id"], name: "index_logs_on_indicator_id", using: :btree
  add_index "logs", ["objective_id"], name: "index_logs_on_objective_id", using: :btree
  add_index "logs", ["task_id"], name: "index_logs_on_task_id", using: :btree
  add_index "logs", ["type"], name: "index_logs_on_type", using: :btree

  create_table "milestones", force: :cascade do |t|
    t.decimal  "value"
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "objectives", force: :cascade do |t|
    t.string   "name",           limit: 255,                 null: false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "area_id",                                    null: false
    t.integer  "hoshin_id",                                  null: false
    t.integer  "obj_pos"
    t.integer  "parent_id"
    t.integer  "responsible_id"
    t.integer  "company_id",                                 null: false
    t.integer  "creator_id"
    t.boolean  "neglected",                  default: false
    t.boolean  "blind",                      default: true
    t.datetime "deleted_at"
  end

  add_index "objectives", ["area_id"], name: "index_objectives_on_area_id", using: :btree
  add_index "objectives", ["company_id"], name: "index_objectives_on_company_id", using: :btree
  add_index "objectives", ["creator_id"], name: "index_objectives_on_creator_id", using: :btree
  add_index "objectives", ["deleted_at"], name: "index_objectives_on_deleted_at", using: :btree
  add_index "objectives", ["hoshin_id"], name: "index_objectives_on_hoshin_id", using: :btree
  add_index "objectives", ["parent_id"], name: "index_objectives_on_parent_id", using: :btree
  add_index "objectives", ["responsible_id"], name: "index_objectives_on_responsible_id", using: :btree

  create_table "payments", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "token",           limit: 255
    t.string   "status",          limit: 255
    t.boolean  "sandbox"
    t.integer  "company_id"
    t.decimal  "amount_value",                precision: 8, scale: 2
    t.string   "amount_currency", limit: 255
    t.integer  "billing_plan_id"
    t.string   "id_paypal",       limit: 255
    t.datetime "deleted_at"
  end

  add_index "payments", ["billing_plan_id"], name: "index_payments_on_billing_plan_id", using: :btree
  add_index "payments", ["company_id"], name: "index_payments_on_company_id", using: :btree
  add_index "payments", ["deleted_at"], name: "index_payments_on_deleted_at", using: :btree
  add_index "payments", ["token"], name: "index_payments_on_token", unique: true, using: :btree
  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "paypal_buttons", force: :cascade do |t|
    t.string   "product",           limit: 255
    t.string   "id_paypal",         limit: 255
    t.string   "id_paypal_sandbox", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "paypal_buttons", ["product"], name: "index_paypal_buttons_on_product", unique: true, using: :btree

  create_table "tasks", force: :cascade do |t|
    t.string   "name",                limit: 255,                     null: false
    t.text     "description"
    t.date     "deadline"
    t.date     "original_deadline"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "objective_id",                                        null: false
    t.string   "status",              limit: 255, default: "backlog"
    t.datetime "key_timestamp"
    t.integer  "tsk_pos"
    t.integer  "area_id",                                             null: false
    t.boolean  "show_on_parent"
    t.string   "type",                limit: 255
    t.integer  "responsible_id"
    t.integer  "company_id",                                          null: false
    t.boolean  "reminder",                        default: true
    t.integer  "creator_id"
    t.integer  "hoshin_id",                                           null: false
    t.integer  "lane_pos",                        default: 0,         null: false
    t.integer  "parent_area_id"
    t.integer  "parent_objective_id"
    t.string   "feeling",             limit: 255, default: "smile",   null: false
    t.datetime "deleted_at"
    t.float    "confidence"
    t.float    "impact"
    t.float    "effort"
  end

  add_index "tasks", ["area_id", "status"], name: "index_tasks_on_area_id_and_status", using: :btree
  add_index "tasks", ["area_id"], name: "index_tasks_on_area_id", using: :btree
  add_index "tasks", ["company_id"], name: "index_tasks_on_company_id", using: :btree
  add_index "tasks", ["creator_id"], name: "index_tasks_on_creator_id", using: :btree
  add_index "tasks", ["deadline", "status"], name: "index_tasks_on_deadline_and_status", using: :btree
  add_index "tasks", ["deleted_at"], name: "index_tasks_on_deleted_at", using: :btree
  add_index "tasks", ["hoshin_id", "status"], name: "index_tasks_on_hoshin_id_and_status", using: :btree
  add_index "tasks", ["hoshin_id"], name: "index_tasks_on_hoshin_id", using: :btree
  add_index "tasks", ["objective_id"], name: "index_tasks_on_objective_id", using: :btree
  add_index "tasks", ["parent_area_id"], name: "index_tasks_on_parent_area_id", using: :btree
  add_index "tasks", ["parent_objective_id"], name: "index_tasks_on_parent_objective_id", using: :btree
  add_index "tasks", ["responsible_id"], name: "index_tasks_on_responsible_id", using: :btree
  add_index "tasks", ["status"], name: "index_tasks_on_status", using: :btree
  add_index "tasks", ["type"], name: "index_tasks_on_type", using: :btree

  create_table "user_companies", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "company_id"
    t.string   "state",         limit: 255
    t.datetime "key_timestamp"
  end

  add_index "user_companies", ["company_id"], name: "index_user_companies_on_company_id", using: :btree
  add_index "user_companies", ["state"], name: "index_user_companies_on_state", using: :btree
  add_index "user_companies", ["user_id", "company_id"], name: "index_user_companies_on_user_id_and_company_id", using: :btree
  add_index "user_companies", ["user_id"], name: "index_user_companies_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "crypted_password",          limit: 40
    t.string   "salt",                      limit: 40
    t.string   "remember_token",            limit: 255
    t.datetime "remember_token_expires_at"
    t.string   "name",                      limit: 255
    t.string   "email_address",             limit: 255
    t.boolean  "administrator",                         default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                     limit: 255, default: "inactive"
    t.datetime "key_timestamp"
    t.string   "image_file_name",           limit: 255
    t.string   "image_content_type",        limit: 255
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "tutorial_step"
    t.string   "timezone",                  limit: 255
    t.string   "color",                     limit: 255
    t.string   "language",                  limit: 255
    t.datetime "last_login_at"
    t.integer  "login_count"
    t.string   "preferred_view",            limit: 255, default: "expanded"
    t.date     "last_seen_at"
    t.integer  "payments_count",                        default: 0,          null: false
    t.string   "firstName",                 limit: 255
    t.string   "lastName",                  limit: 255
  end

  add_index "users", ["email_address"], name: "index_users_on_email_address", unique: true, using: :btree
  add_index "users", ["state"], name: "index_users_on_state", using: :btree

end
