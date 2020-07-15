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

ActiveRecord::Schema.define(version: 2020_07_15_183442) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "account_companies_permissions", id: :uuid, default: -> { "uuid_generate_v1mc()" }, force: :cascade do |t|
    t.uuid "company_id", null: false
    t.uuid "permission_id", null: false
    t.index ["company_id", "permission_id"], name: "aop_oi_pi_idx", unique: true
    t.index ["company_id"], name: "index_account_companies_permissions_on_company_id"
    t.index ["permission_id"], name: "index_account_companies_permissions_on_permission_id"
  end

  create_table "audits", force: :cascade do |t|
    t.uuid "auditable_id"
    t.string "auditable_type"
    t.uuid "associated_id"
    t.string "associated_type"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.text "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.uuid "user_id"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "companies", id: :uuid, default: -> { "uuid_generate_v1mc()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "phone_number"
    t.string "email"
  end

  create_table "companies_users", id: :uuid, default: -> { "uuid_generate_v1mc()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "company_id", null: false
    t.index ["company_id"], name: "index_companies_users_on_company_id"
    t.index ["user_id"], name: "index_companies_users_on_user_id"
  end

  create_table "permissions", id: :uuid, default: -> { "uuid_generate_v1mc()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "controller"
    t.string "action"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description", null: false
    t.index ["name"], name: "index_permissions_on_name", unique: true
  end

  create_table "roles", id: :uuid, default: -> { "uuid_generate_v1mc()" }, force: :cascade do |t|
    t.string "name", null: false
    t.uuid "company_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_roles_on_company_id"
  end

  create_table "roles_permissions", id: :uuid, default: -> { "uuid_generate_v1mc()" }, force: :cascade do |t|
    t.uuid "role_id", null: false
    t.uuid "permission_id", null: false
    t.index ["permission_id"], name: "index_roles_permissions_on_permission_id"
    t.index ["role_id"], name: "index_roles_permissions_on_role_id"
  end

  create_table "users", id: :uuid, default: -> { "uuid_generate_v1mc()" }, force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_created_at"
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.integer "role", default: 1, null: false
    t.boolean "confirmed", default: false, null: false
    t.datetime "confirmed_at"
    t.string "confirmation_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.uuid "role_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  add_foreign_key "account_companies_permissions", "companies"
  add_foreign_key "account_companies_permissions", "permissions"
  add_foreign_key "companies_users", "companies"
  add_foreign_key "companies_users", "users"
  add_foreign_key "roles", "companies"
  add_foreign_key "roles_permissions", "permissions"
  add_foreign_key "roles_permissions", "roles"
  add_foreign_key "users", "roles"
end
