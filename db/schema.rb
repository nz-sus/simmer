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

ActiveRecord::Schema[7.1].define(version: 2024_09_18_231308) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "clients", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data_sets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "time_range_start"
    t.datetime "time_range_end"
    t.uuid "client_id"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "schema_name", default: "none", null: false
    t.string "source_url"
    t.index ["client_id"], name: "index_data_sets_on_client_id"
  end

  create_table "gitleaks_results", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "description"
    t.integer "start_line"
    t.integer "end_line"
    t.integer "start_column"
    t.integer "end_column"
    t.string "match"
    t.string "secret"
    t.string "file"
    t.string "symlink_file"
    t.string "commit"
    t.float "entropy"
    t.string "author"
    t.string "email"
    t.datetime "date"
    t.text "message"
    t.text "gltags"
    t.string "rule_id"
    t.string "fingerprint"
    t.uuid "log_entry_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "severity", default: "UNKNOWN", null: false
    t.uuid "data_set_id"
    t.uuid "masked_secret_id"
    t.index ["log_entry_id"], name: "index_gitleaks_results_on_log_entry_id"
    t.index ["masked_secret_id"], name: "index_gitleaks_results_on_masked_secret_id"
    t.index ["severity"], name: "index_gitleaks_results_on_severity"
  end

  create_table "gitleaks_results_incidents", id: false, force: :cascade do |t|
    t.uuid "gitleaks_result_id", null: false
    t.uuid "incident_id", null: false
    t.index ["gitleaks_result_id", "incident_id"], name: "index_gitleaks_results_incidents_on_both_ids", unique: true
    t.index ["gitleaks_result_id"], name: "index_gitleaks_results_incidents_on_gitleaks_result_id"
    t.index ["incident_id"], name: "index_gitleaks_results_incidents_on_incident_id"
  end

  create_table "incidents", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "opened_at"
    t.datetime "closed_at"
    t.uuid "client_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_incidents_on_client_id"
  end

  create_table "log_entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.string "data_schema"
    t.datetime "timestamp"
    t.text "data_json"
    t.uuid "data_set_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source", default: "", null: false
    t.index ["data_set_id"], name: "index_log_entries_on_data_set_id"
  end

  create_table "masked_secrets", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "count"
    t.text "notes"
    t.string "secret"
    t.string "secret_hash"
    t.uuid "client_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "rule_id"
    t.string "severity", default: "UNKNOWN", null: false
    t.index ["client_id"], name: "index_masked_secrets_on_client_id"
  end

  create_table "notes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "content"
    t.string "noteable_type", null: false
    t.uuid "noteable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["noteable_type", "noteable_id"], name: "index_notes_on_noteable"
    t.index ["noteable_type", "noteable_id"], name: "index_notes_on_noteable_type_and_noteable_id"
  end

  create_table "service_tokens", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "token"
    t.bigint "user_id", null: false
    t.string "permission"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_service_tokens_on_user_id"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id"
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.string "tagger_type"
    t.bigint "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: nil
    t.string "tenant", limit: 128
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
    t.index ["tagger_type", "tagger_id"], name: "index_taggings_on_tagger_type_and_tagger_id"
    t.index ["tenant"], name: "index_taggings_on_tenant"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "data_sets", "clients"
  add_foreign_key "gitleaks_results", "log_entries"
  add_foreign_key "gitleaks_results", "masked_secrets"
  add_foreign_key "gitleaks_results_incidents", "gitleaks_results"
  add_foreign_key "gitleaks_results_incidents", "incidents"
  add_foreign_key "incidents", "clients"
  add_foreign_key "log_entries", "data_sets"
  add_foreign_key "masked_secrets", "clients"
  add_foreign_key "service_tokens", "users"
  add_foreign_key "taggings", "tags"
end
