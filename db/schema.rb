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

ActiveRecord::Schema.define(version: 2019_04_03_024001) do

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

  create_table "data_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "imports", force: :cascade do |t|
    t.string "title", null: false
    t.string "import_type"
    t.bigint "user_id"
    t.boolean "approved"
    t.bigint "approved_by_id"
    t.text "log"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "aasm_state"
    t.boolean "xlsx_valid"
    t.text "reason"
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
    t.boolean "dubious"
    t.integer "validated"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "validation_type_id"
    t.index ["measurement_method_id"], name: "index_measurements_on_measurement_method_id"
    t.index ["measurement_model_id"], name: "index_measurements_on_measurement_model_id"
    t.index ["observation_id"], name: "index_measurements_on_observation_id"
    t.index ["precision_type_id"], name: "index_measurements_on_precision_type_id"
    t.index ["sex_type_id"], name: "index_measurements_on_sex_type_id"
    t.index ["standard_id"], name: "index_measurements_on_standard_id"
    t.index ["trait_class_id"], name: "index_measurements_on_trait_class_id"
    t.index ["trait_id"], name: "index_measurements_on_trait_id"
    t.index ["validation_type_id"], name: "index_measurements_on_validation_type_id"
    t.index ["value_type_id"], name: "index_measurements_on_value_type_id"
  end

  create_table "observations", force: :cascade do |t|
    t.bigint "species_id"
    t.bigint "longhurst_province_id"
    t.string "date"
    t.string "access"
    t.boolean "hidden"
    t.bigint "user_id"
    t.bigint "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "contributor_id"
    t.string "depth"
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
    t.string "data_source"
    t.string "year"
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
    t.bigint "species_data_type_id"
    t.bigint "species_subclass_id"
    t.bigint "species_order_id"
    t.bigint "species_family_id"
    t.string "edge_scientific_name"
    t.string "scientific_name"
    t.string "authorship"
    t.index ["species_data_type_id"], name: "index_species_on_species_data_type_id"
    t.index ["species_family_id"], name: "index_species_on_species_family_id"
    t.index ["species_order_id"], name: "index_species_on_species_order_id"
    t.index ["species_subclass_id"], name: "index_species_on_species_subclass_id"
    t.index ["species_superorder_id"], name: "index_species_on_species_superorder_id"
  end

  create_table "species_data_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "species_families", force: :cascade do |t|
    t.string "name"
    t.bigint "species_subclass_id"
    t.bigint "species_superorder_id"
    t.bigint "species_order_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["species_order_id"], name: "index_species_families_on_species_order_id"
    t.index ["species_subclass_id"], name: "index_species_families_on_species_subclass_id"
    t.index ["species_superorder_id"], name: "index_species_families_on_species_superorder_id"
  end

  create_table "species_orders", force: :cascade do |t|
    t.string "name"
    t.bigint "species_superorder_id"
    t.bigint "species_subclass_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["species_subclass_id"], name: "index_species_orders_on_species_subclass_id"
    t.index ["species_superorder_id"], name: "index_species_orders_on_species_superorder_id"
  end

  create_table "species_subclasses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "species_superorders", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "species_subclass_id"
    t.index ["species_subclass_id"], name: "index_species_superorders_on_species_subclass_id"
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

  create_table "trend_observations", force: :cascade do |t|
    t.bigint "trend_id"
    t.string "year", null: false
    t.string "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trend_id"], name: "index_trend_observations_on_trend_id"
  end

  create_table "trends", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "species_id"
    t.bigint "location_id"
    t.bigint "ocean_id"
    t.bigint "data_type_id"
    t.bigint "sampling_method_id"
    t.integer "no_years"
    t.integer "time_min"
    t.text "taxonomic_notes"
    t.string "page_and_figure_number"
    t.string "line_used"
    t.integer "pdf_page"
    t.integer "actual_page"
    t.string "depth"
    t.string "model"
    t.string "figure_name"
    t.string "figure_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "resource_id"
    t.bigint "standard_id"
    t.index ["data_type_id"], name: "index_trends_on_data_type_id"
    t.index ["location_id"], name: "index_trends_on_location_id"
    t.index ["ocean_id"], name: "index_trends_on_ocean_id"
    t.index ["resource_id"], name: "index_trends_on_resource_id"
    t.index ["sampling_method_id"], name: "index_trends_on_sampling_method_id"
    t.index ["species_id"], name: "index_trends_on_species_id"
    t.index ["standard_id"], name: "index_trends_on_standard_id"
    t.index ["user_id"], name: "index_trends_on_user_id"
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

  create_table "validation_types", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "value_types", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
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
  add_foreign_key "measurements", "validation_types"
  add_foreign_key "measurements", "value_types"
  add_foreign_key "observations", "locations"
  add_foreign_key "observations", "longhurst_provinces"
  add_foreign_key "observations", "species"
  add_foreign_key "observations", "users"
  add_foreign_key "species", "species_data_types"
  add_foreign_key "species", "species_families"
  add_foreign_key "species", "species_orders"
  add_foreign_key "species", "species_subclasses"
  add_foreign_key "species_families", "species_orders"
  add_foreign_key "species_families", "species_subclasses"
  add_foreign_key "species_families", "species_superorders"
  add_foreign_key "species_orders", "species_subclasses"
  add_foreign_key "species_orders", "species_superorders"
  add_foreign_key "species_superorders", "species_subclasses"
  add_foreign_key "standards", "trait_classes"
  add_foreign_key "traits", "trait_classes"
  add_foreign_key "trend_observations", "trends"
  add_foreign_key "trends", "data_types"
  add_foreign_key "trends", "locations"
  add_foreign_key "trends", "oceans"
  add_foreign_key "trends", "resources"
  add_foreign_key "trends", "sampling_methods"
  add_foreign_key "trends", "species"
  add_foreign_key "trends", "standards"
  add_foreign_key "trends", "users"
end
