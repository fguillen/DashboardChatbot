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

ActiveRecord::Schema[7.2].define(version: 2024_12_01_192353) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "vector"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "reaction_kind", ["positive", "negative"]

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_id", null: false
    t.string "record_type", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
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

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_authorizations", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "admin_user_id"
    t.text "omniauth_data"
    t.text "omniauth_params"
    t.index ["admin_user_id"], name: "index_admin_authorizations_on_admin_user_id"
  end

  create_table "admin_users", primary_key: "uuid", id: :string, force: :cascade do |t|
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

  create_table "alert_emails", primary_key: "uuid", id: { type: :string, limit: 36 }, force: :cascade do |t|
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

  create_table "alerts", primary_key: "uuid", id: { type: :string, limit: 36 }, force: :cascade do |t|
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

  create_table "articles", primary_key: "uuid", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.string "title", null: false
    t.text "body", null: false
    t.string "front_user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["front_user_id"], name: "fk_rails_1451c23bee"
    t.index ["uuid"], name: "index_articles_on_uuid", unique: true
  end

  create_table "conversations", primary_key: "uuid", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.string "title", null: false
    t.string "front_user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "alert_email_id"
    t.index ["alert_email_id"], name: "fk_rails_f29ffbaed7"
    t.index ["front_user_id"], name: "fk_rails_4db8d566b8"
    t.index ["uuid"], name: "index_conversations_on_uuid", unique: true
  end

  create_table "data_migrations", primary_key: "version", id: :string, force: :cascade do |t|
  end

  create_table "front_authorizations", force: :cascade do |t|
    t.string "provider"
    t.string "uid"
    t.string "front_user_id"
    t.text "omniauth_data"
    t.text "omniauth_params"
    t.index ["front_user_id"], name: "index_front_authorizations_on_front_user_id"
  end

  create_table "front_users", primary_key: "uuid", id: :string, force: :cascade do |t|
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

  create_table "log_book_events", id: :serial, force: :cascade do |t|
    t.string "historian_id", limit: 36
    t.string "historian_type", limit: 255
    t.string "historizable_id", limit: 36
    t.string "historizable_type", limit: 255
    t.text "differences"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["created_at"], name: "log_book_events_created_at_idx"
    t.index ["historizable_id", "historizable_type", "created_at"], name: "log_book_events_historizabb4698-4319-4be5-87c9-c6c1ed13ebd2_idx"
  end

  create_table "messages", primary_key: "uuid", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.integer "order", null: false
    t.string "role", limit: 255, null: false
    t.text "content"
    t.string "tool_call_id", limit: 255
    t.string "conversation_id", limit: 255
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.json "raw"
    t.string "model", limit: 255
    t.json "tool_calls"
    t.json "completion_raw"
    t.index ["conversation_id"], name: "messages_conversation_id_idx"
    t.index ["uuid"], name: "messages_uuid_idx", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", limit: 255, null: false
    t.text "data"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["session_id"], name: "sessions_session_id_idx"
    t.index ["updated_at"], name: "sessions_updated_at_idx"
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type", limit: 255
    t.string "taggable_id", limit: 36
    t.string "tagger_type", limit: 255
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.index ["context"], name: "taggings_context_idx"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_tag_id_taggable_i60a9b-9e86-4fc5-a017-74739e1d8217_idx", unique: true
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_id_taggable_type_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_taggable_id_taggable_type_tagger_id_context_idx"
    t.index ["taggable_id"], name: "taggings_taggable_id_idx"
    t.index ["taggable_type"], name: "taggings_taggable_type_idx"
    t.index ["tagger_id", "tagger_type"], name: "taggings_tagger_id_tagger_type_idx"
    t.index ["tagger_id"], name: "taggings_tagger_id_idx"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "updated_at", precision: nil
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "tags_name_idx", unique: true
  end

  create_table "user_favorites", primary_key: "uuid", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.text "prompt"
    t.text "model_mental_process"
    t.vector "prompt_embedding", limit: 384
    t.string "user_reaction_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_user_favorites_on_uuid", unique: true
  end

  create_table "user_notifications_configs", primary_key: "uuid", id: { type: :string, limit: 255 }, force: :cascade do |t|
    t.json "active_notifications"
    t.string "user_id", limit: 255
    t.string "user_type", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_type", "user_id"], name: "user_notifications_configs_user_type_user_id_idx", unique: true
    t.index ["uuid"], name: "user_notifications_configs_uuid_idx", unique: true
  end

  create_table "user_reactions", primary_key: "uuid", id: { type: :string, limit: 36 }, force: :cascade do |t|
    t.string "message_id", null: false
    t.enum "kind", null: false, enum_type: "reaction_kind"
    t.text "explanation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uuid"], name: "index_user_reactions_on_uuid", unique: true
  end

  add_foreign_key "taggings", "tags", name: "taggings_tag_id_fkey"
  add_foreign_key "user_favorites", "user_reactions", primary_key: "uuid"
  add_foreign_key "user_reactions", "messages", primary_key: "uuid"
end
