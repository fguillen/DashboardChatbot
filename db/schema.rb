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

ActiveRecord::Schema[7.1].define(version: 2024_09_28_092231) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_id", null: false
    t.string "record_type", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: nil, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_authorizations", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "admin_user_id"
    t.text "omniauth_data"
    t.text "omniauth_params"
    t.index ["admin_user_id"], name: "index_admin_authorizations_on_admin_user_id"
  end

  create_table "admin_users", primary_key: "uuid", id: :string, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "password_salt"
    t.string "perishable_token"
    t.string "persistence_token"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "notifications_active"
    t.index ["perishable_token"], name: "index_admin_users_on_perishable_token", unique: true
    t.index ["persistence_token"], name: "index_admin_users_on_persistence_token", unique: true
    t.index ["uuid"], name: "index_admin_users_on_uuid", unique: true
  end

  create_table "alert_emails", primary_key: "uuid", id: { type: :string, limit: 36 }, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "subject"
    t.text "content"
    t.string "from"
    t.string "to"
    t.string "alert_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["alert_id"], name: "fk_rails_6b6ec42417"
    t.index ["uuid"], name: "index_alert_emails_on_uuid", unique: true
  end

  create_table "alerts", primary_key: "uuid", id: { type: :string, limit: 36 }, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "schedule", null: false
    t.text "context", null: false
    t.text "prompt", null: false
    t.string "name", null: false
    t.string "conversation_id"
    t.string "front_user_id"
    t.string "model"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "fk_rails_06c02833b7"
    t.index ["front_user_id"], name: "fk_rails_7f4748ff04"
    t.index ["uuid"], name: "index_alerts_on_uuid", unique: true
  end

  create_table "articles", primary_key: "uuid", id: { type: :string, limit: 36 }, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.string "front_user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["front_user_id"], name: "fk_rails_1451c23bee"
    t.index ["uuid"], name: "index_articles_on_uuid", unique: true
  end

  create_table "conversations", primary_key: "uuid", id: { type: :string, limit: 36 }, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "title", null: false
    t.string "front_user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "alert_email_id"
    t.index ["alert_email_id"], name: "fk_rails_f29ffbaed7"
    t.index ["front_user_id"], name: "fk_rails_4db8d566b8"
    t.index ["uuid"], name: "index_conversations_on_uuid", unique: true
  end

  create_table "data_migrations", primary_key: "version", id: :string, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
  end

  create_table "front_authorizations", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "front_user_id"
    t.text "omniauth_data"
    t.text "omniauth_params"
    t.index ["front_user_id"], name: "index_front_authorizations_on_front_user_id"
  end

  create_table "front_users", primary_key: "uuid", id: :string, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "crypted_password"
    t.string "password_salt"
    t.string "perishable_token"
    t.string "persistence_token"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "notifications_active"
    t.string "api_token"
    t.index ["perishable_token"], name: "index_front_users_on_perishable_token", unique: true
    t.index ["persistence_token"], name: "index_front_users_on_persistence_token", unique: true
    t.index ["uuid"], name: "index_front_users_on_uuid", unique: true
  end

  create_table "log_book_events", id: :integer, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "historian_id", limit: 36
    t.string "historian_type"
    t.string "historizable_id", limit: 36
    t.string "historizable_type"
    t.text "differences", size: :medium
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["created_at"], name: "index_log_book_events_on_created_at"
    t.index ["historizable_id", "historizable_type", "created_at"], name: "index_log_book_events_on_historizable_and_created_at"
  end

  create_table "messages", primary_key: "uuid", id: { type: :string, limit: 36 }, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "order", null: false
    t.string "role", null: false
    t.text "content"
    t.string "tool_call_id"
    t.string "conversation_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.json "raw"
    t.string "model"
    t.json "tool_calls"
    t.json "completion_raw"
    t.index ["conversation_id"], name: "fk_rails_7f927086d2"
    t.index ["uuid"], name: "index_messages_on_uuid", unique: true
  end

  create_table "sessions", charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id"
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "taggings", id: :integer, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.string "taggable_id", limit: 36
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :integer, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.string "name", collation: "utf8mb3_bin"
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "user_notifications_configs", primary_key: "uuid", id: :string, charset: "utf8mb4", collation: "utf8mb4_bin", force: :cascade do |t|
    t.json "active_notifications"
    t.string "user_id"
    t.string "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_type", "user_id"], name: "index_user_notifications_configs_on_user_type_and_user_id", unique: true
    t.index ["uuid"], name: "index_user_notifications_configs_on_uuid", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "alert_emails", "alerts", primary_key: "uuid"
  add_foreign_key "alerts", "conversations", primary_key: "uuid"
  add_foreign_key "alerts", "front_users", primary_key: "uuid"
  add_foreign_key "articles", "front_users", primary_key: "uuid"
  add_foreign_key "conversations", "alert_emails", primary_key: "uuid"
  add_foreign_key "conversations", "front_users", primary_key: "uuid"
  add_foreign_key "messages", "conversations", primary_key: "uuid"
  add_foreign_key "taggings", "tags"
end
