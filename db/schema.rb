# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2024_02_28_173156) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "subscription_id"
    t.string "name"
    t.boolean "is_main", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "parent_account_id"
    t.boolean "can_have_sub_accounts", default: false
    t.string "alt_id"
    t.jsonb "settings"
    t.index ["organization_id"], name: "index_accounts_on_organization_id"
    t.index ["parent_account_id"], name: "index_accounts_on_parent_account_id"
    t.index ["subscription_id"], name: "index_accounts_on_subscription_id"
  end

  create_table "action_executions", force: :cascade do |t|
    t.bigint "action_id"
    t.bigint "user_id"
    t.datetime "run_at"
    t.integer "status", default: 0
    t.jsonb "data", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["action_id"], name: "index_action_executions_on_action_id"
    t.index ["user_id"], name: "index_action_executions_on_user_id"
  end

  create_table "actions", force: :cascade do |t|
    t.bigint "note_id"
    t.string "type"
    t.jsonb "data", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["note_id"], name: "index_actions_on_note_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: 6, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "block_references", force: :cascade do |t|
    t.bigint "note_id", null: false
    t.string "referenced_block_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["note_id"], name: "index_block_references_on_note_id"
    t.index ["referenced_block_id"], name: "index_block_references_on_referenced_block_id", unique: true
  end

  create_table "external_sign_ups", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email", null: false
    t.string "alt_id"
    t.string "source"
    t.string "interest_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_external_sign_ups_on_organization_id"
  end

  create_table "interactions", force: :cascade do |t|
    t.string "type"
    t.bigint "user_id"
    t.jsonb "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_interactions_on_account_id"
    t.index ["user_id"], name: "index_interactions_on_user_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "sender_id"
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.text "content"
    t.jsonb "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "context_type"
    t.bigint "context_id"
    t.index ["context_type", "context_id"], name: "index_messages_on_context"
    t.index ["recipient_type", "recipient_id"], name: "index_messages_on_recipient"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "note_instances", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "note_id", null: false
    t.jsonb "fill_in_values", default: {}
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["note_id"], name: "index_note_instances_on_note_id"
    t.index ["user_id"], name: "index_note_instances_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "title"
    t.string "background_color"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "banner_url"
    t.string "alt_id"
    t.integer "sharing", default: 0
    t.jsonb "editor_data", default: {}
    t.index ["account_id"], name: "index_notes_on_account_id"
  end

  create_table "organization_members", force: :cascade do |t|
    t.bigint "organization_id"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_organization_members_on_organization_id"
    t.index ["user_id"], name: "index_organization_members_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.integer "plan", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "encoded_name"
    t.string "alt_id", null: false
    t.index ["encoded_name"], name: "index_organizations_on_encoded_name", unique: true
  end

  create_table "schedules", force: :cascade do |t|
    t.bigint "note_id", null: false
    t.datetime "start_at", precision: 6
    t.datetime "end_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "account_id"
    t.index ["account_id"], name: "index_schedules_on_account_id"
    t.index ["note_id"], name: "index_schedules_on_note_id"
  end

  create_table "sign_ups", force: :cascade do |t|
    t.string "alt_id", null: false
    t.bigint "organization_id"
    t.bigint "subscription_id"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.string "source"
    t.integer "plan"
    t.jsonb "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["alt_id"], name: "index_sign_ups_on_alt_id", unique: true
    t.index ["organization_id"], name: "index_sign_ups_on_organization_id"
    t.index ["subscription_id"], name: "index_sign_ups_on_subscription_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.string "stripe_subscription_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "status", default: 0
    t.integer "purchased_sub_accounts", default: 0
    t.string "stripe_customer_id"
    t.bigint "origin_account_id"
    t.index ["origin_account_id"], name: "index_subscriptions_on_origin_account_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.integer "action", default: 0
    t.text "value", null: false
    t.boolean "active", default: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "type"
    t.string "alt_id", null: false
    t.index ["user_id"], name: "index_tokens_on_user_id"
  end

  create_table "user_account_member_roles", force: :cascade do |t|
    t.bigint "user_account_member_id", null: false
    t.integer "role", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_account_member_id"], name: "index_user_account_member_roles_on_user_account_member_id"
  end

  create_table "user_account_members", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "account_id", null: false
    t.boolean "is_default", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["account_id", "user_id"], name: "index_user_account_members_on_account_id_and_user_id"
    t.index ["account_id"], name: "index_user_account_members_on_account_id"
    t.index ["user_id", "account_id"], name: "index_user_account_members_on_user_id_and_account_id"
    t.index ["user_id"], name: "index_user_account_members_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.text "password_digest"
    t.string "provider"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "time_zone", default: "Pacific Time (US & Canada)"
    t.boolean "is_staff", default: false
    t.string "stripe_customer_id"
  end

  add_foreign_key "accounts", "accounts", column: "parent_account_id"
  add_foreign_key "accounts", "organizations"
  add_foreign_key "accounts", "subscriptions"
  add_foreign_key "action_executions", "actions"
  add_foreign_key "action_executions", "users"
  add_foreign_key "actions", "notes"
  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "block_references", "notes"
  add_foreign_key "external_sign_ups", "organizations"
  add_foreign_key "messages", "users", column: "sender_id"
  add_foreign_key "note_instances", "notes"
  add_foreign_key "note_instances", "users"
  add_foreign_key "notes", "accounts"
  add_foreign_key "schedules", "accounts"
  add_foreign_key "schedules", "notes"
  add_foreign_key "subscriptions", "accounts", column: "origin_account_id"
  add_foreign_key "tokens", "users"
  add_foreign_key "user_account_member_roles", "user_account_members"
  add_foreign_key "user_account_members", "accounts"
  add_foreign_key "user_account_members", "users"
end
