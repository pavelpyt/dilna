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

ActiveRecord::Schema[8.1].define(version: 2026_07_25_205338) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name", null: false
    t.string "phone"
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_accounts_on_slug", unique: true
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "clients", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.string "client_type", default: "company", null: false
    t.string "company_registration_number"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name", null: false
    t.text "note"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.string "vat_identification_number"
    t.index ["account_id"], name: "index_clients_on_account_id"
  end

  create_table "contacts", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.string "email"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone"
    t.string "position"
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_contacts_on_client_id"
  end

  create_table "job_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description", null: false
    t.bigint "job_id", null: false
    t.integer "position", default: 0, null: false
    t.decimal "quantity", precision: 10, scale: 2, default: "1.0", null: false
    t.bigint "service_id"
    t.string "unit", default: "ks", null: false
    t.decimal "unit_price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.integer "vat_rate", default: 21, null: false
    t.index ["job_id"], name: "index_job_items_on_job_id"
    t.index ["service_id"], name: "index_job_items_on_service_id"
  end

  create_table "job_photos", force: :cascade do |t|
    t.string "caption"
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["job_id"], name: "index_job_photos_on_job_id"
    t.index ["user_id"], name: "index_job_photos_on_user_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "number", null: false
    t.bigint "property_id"
    t.datetime "scheduled_end_at"
    t.datetime "scheduled_start_at"
    t.string "status", default: "inquiry", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id", "number"], name: "index_jobs_on_account_id_and_number", unique: true
    t.index ["account_id", "status"], name: "index_jobs_on_account_id_and_status"
    t.index ["account_id"], name: "index_jobs_on_account_id"
    t.index ["client_id"], name: "index_jobs_on_client_id"
    t.index ["property_id"], name: "index_jobs_on_property_id"
  end

  create_table "notes", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.bigint "job_id", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["job_id"], name: "index_notes_on_job_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "properties", force: :cascade do |t|
    t.string "city", null: false
    t.bigint "client_id", null: false
    t.datetime "created_at", null: false
    t.string "label"
    t.decimal "latitude", precision: 10, scale: 6
    t.decimal "longitude", precision: 10, scale: 6
    t.text "note"
    t.string "postal_code"
    t.string "street", null: false
    t.datetime "updated_at", null: false
    t.index ["client_id"], name: "index_properties_on_client_id"
  end

  create_table "services", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.boolean "archived", default: false, null: false
    t.datetime "created_at", null: false
    t.integer "margin_percent"
    t.string "name", null: false
    t.string "unit", default: "ks", null: false
    t.decimal "unit_price", precision: 10, scale: 2, default: "0.0", null: false
    t.datetime "updated_at", null: false
    t.integer "vat_rate", default: 21, null: false
    t.index ["account_id"], name: "index_services_on_account_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "phone"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.string "role", default: "staff", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_users_on_account_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "clients", "accounts"
  add_foreign_key "contacts", "clients"
  add_foreign_key "job_items", "jobs"
  add_foreign_key "job_items", "services"
  add_foreign_key "job_photos", "jobs"
  add_foreign_key "job_photos", "users"
  add_foreign_key "jobs", "accounts"
  add_foreign_key "jobs", "clients"
  add_foreign_key "jobs", "properties"
  add_foreign_key "notes", "jobs"
  add_foreign_key "notes", "users"
  add_foreign_key "properties", "clients"
  add_foreign_key "services", "accounts"
  add_foreign_key "users", "accounts"
end
