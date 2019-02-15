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

ActiveRecord::Schema.define(version: 2019_02_15_215911) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "imports", force: :cascade do |t|
    t.string "title", null: false
    t.string "import_type", null: false
    t.bigint "user_id"
    t.boolean "approved"
    t.bigint "approved_by_id"
    t.text "log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by_id"], name: "index_imports_on_approved_by_id"
    t.index ["user_id"], name: "index_imports_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.decimal "lat", precision: 15, scale: 10
    t.decimal "lon", precision: 15, scale: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "longhurst_provinces", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_longhurst_provinces_on_code"
  end

  create_table "measurement_methods", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "trait_class_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trait_class_id"], name: "index_measurement_methods_on_trait_class_id"
  end

  create_table "measurement_models", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "trait_class_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trait_class_id"], name: "index_measurement_models_on_trait_class_id"
  end

  create_table "measurements", force: :cascade do |t|
    t.bigint "observation_id"
    t.bigint "sex_type_id"
    t.bigint "trait_class_id"
    t.bigint "trait_id"
    t.bigint "standard_id"
    t.bigint "measurement_method_id"
    t.bigint "measurement_model_id"
    t.string "value"
    t.bigint "value_type_id"
    t.string "precision"
    t.bigint "precision_type_id"
    t.string "precision_upper"
    t.integer "sample_size"
    t.integer "dubious"
    t.integer "validated"
    t.string "validation_type"
    t.text "notes"
    t.string "depth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["measurement_method_id"], name: "index_measurements_on_measurement_method_id"
    t.index ["measurement_model_id"], name: "index_measurements_on_measurement_model_id"
    t.index ["observation_id"], name: "index_measurements_on_observation_id"
    t.index ["precision_type_id"], name: "index_measurements_on_precision_type_id"
    t.index ["sex_type_id"], name: "index_measurements_on_sex_type_id"
    t.index ["standard_id"], name: "index_measurements_on_standard_id"
    t.index ["trait_class_id"], name: "index_measurements_on_trait_class_id"
    t.index ["trait_id"], name: "index_measurements_on_trait_id"
    t.index ["value_type_id"], name: "index_measurements_on_value_type_id"
  end

  create_table "observations", force: :cascade do |t|
    t.bigint "species_id"
    t.bigint "longhurst_province_id"
    t.string "date"
    t.string "access"
    t.integer "hidden"
    t.bigint "user_id"
    t.bigint "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "external_id"
    t.string "contributor_id"
    t.index ["external_id"], name: "index_observations_on_external_id"
    t.index ["location_id"], name: "index_observations_on_location_id"
    t.index ["longhurst_province_id"], name: "index_observations_on_longhurst_province_id"
    t.index ["species_id"], name: "index_observations_on_species_id"
    t.index ["user_id"], name: "index_observations_on_user_id"
  end

  create_table "observations_resources", id: false, force: :cascade do |t|
    t.bigint "observation_id", null: false
    t.bigint "resource_id", null: false
    t.index ["observation_id", "resource_id"], name: "index_observations_resources_on_observation_id_and_resource_id"
    t.index ["resource_id", "observation_id"], name: "index_observations_resources_on_resource_id_and_observation_id"
  end

  create_table "oceans", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "precision_types", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "resources", force: :cascade do |t|
    t.string "name", null: false
    t.string "doi"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sampling_methods", force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "sex_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "species", force: :cascade do |t|
    t.string "name", null: false
    t.string "iucn_code"
    t.bigint "species_superorder_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["species_superorder_id"], name: "index_species_on_species_superorder_id"
  end

  create_table "species_superorders", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "standards", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "trait_class_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trait_class_id"], name: "index_standards_on_trait_class_id"
  end

  create_table "trait_classes", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "traits", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "trait_class_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trait_class_id"], name: "index_traits_on_trait_class_id"
  end

  create_table "units", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "user_level", default: "user"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "value_types", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "imports", "users"
  add_foreign_key "imports", "users", column: "approved_by_id"
  add_foreign_key "measurement_methods", "trait_classes"
  add_foreign_key "measurement_models", "trait_classes"
  add_foreign_key "measurements", "measurement_methods"
  add_foreign_key "measurements", "measurement_models"
  add_foreign_key "measurements", "observations"
  add_foreign_key "measurements", "precision_types"
  add_foreign_key "measurements", "sex_types"
  add_foreign_key "measurements", "standards"
  add_foreign_key "measurements", "trait_classes"
  add_foreign_key "measurements", "traits"
  add_foreign_key "measurements", "value_types"
  add_foreign_key "observations", "locations"
  add_foreign_key "observations", "longhurst_provinces"
  add_foreign_key "observations", "species"
  add_foreign_key "observations", "users"
  add_foreign_key "standards", "trait_classes"
  add_foreign_key "traits", "trait_classes"
end
