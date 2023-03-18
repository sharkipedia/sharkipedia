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

ActiveRecord::Schema[7.0].define(version: 2023_03_11_162627) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
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

  create_table "analysis_models", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "data_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "eez_v11", primary_key: "fid", id: :serial, force: :cascade do |t|
    t.float "mrgid"
    t.string "geoname", limit: 80
    t.float "mrgid_ter1"
    t.string "pol_type", limit: 80
    t.float "mrgid_sov1"
    t.string "territory1", limit: 80
    t.string "iso_ter1", limit: 80
    t.string "sovereign1", limit: 80
    t.float "mrgid_ter2"
    t.float "mrgid_sov2"
    t.string "territory2", limit: 80
    t.string "iso_ter2", limit: 80
    t.string "sovereign2", limit: 80
    t.float "mrgid_ter3"
    t.float "mrgid_sov3"
    t.string "territory3", limit: 80
    t.string "iso_ter3", limit: 80
    t.string "sovereign3", limit: 80
    t.float "x_1"
    t.float "y_1"
    t.float "mrgid_eez"
    t.float "area_km2"
    t.string "iso_sov1", limit: 80
    t.string "iso_sov2", limit: 80
    t.string "iso_sov3", limit: 80
    t.bigint "un_sov1"
    t.bigint "un_sov2"
    t.bigint "un_sov3"
    t.bigint "un_ter1"
    t.bigint "un_ter2"
    t.bigint "un_ter3"
    t.geometry "geom", limit: {:srid=>4326, :type=>"multi_polygon"}
    t.index ["geom"], name: "eez_v11_geom_geom_idx", using: :gist
  end

  create_table "fao_areas", force: :cascade do |t|
    t.string "f_code", null: false
    t.string "f_level", null: false
    t.bigint "ocean_id", null: false
    t.string "f_area"
    t.string "f_subarea"
    t.string "f_division"
    t.string "f_subdivision"
    t.string "f_subunit"
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["f_code"], name: "index_fao_areas_on_f_code"
    t.index ["ocean_id"], name: "index_fao_areas_on_ocean_id"
  end

  create_table "fao_areas_trends", id: false, force: :cascade do |t|
    t.bigint "fao_area_id", null: false
    t.bigint "trend_id", null: false
    t.index ["fao_area_id", "trend_id"], name: "index_fao_areas_trends_on_fao_area_id_and_trend_id"
    t.index ["trend_id", "fao_area_id"], name: "index_fao_areas_trends_on_trend_id_and_fao_area_id"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string "slug", null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope"
    t.datetime "created_at", precision: nil
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_type", "sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_type_and_sluggable_id"
  end

  create_table "good_job_processes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "state"
  end

  create_table "good_job_settings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "key"
    t.jsonb "value"
    t.index ["key"], name: "index_good_job_settings_on_key", unique: true
  end

  create_table "good_jobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "queue_name"
    t.integer "priority"
    t.jsonb "serialized_params"
    t.datetime "scheduled_at"
    t.datetime "performed_at"
    t.datetime "finished_at"
    t.text "error"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "active_job_id"
    t.text "concurrency_key"
    t.text "cron_key"
    t.uuid "retried_good_job_id"
    t.datetime "cron_at"
    t.index ["active_job_id", "created_at"], name: "index_good_jobs_on_active_job_id_and_created_at"
    t.index ["active_job_id"], name: "index_good_jobs_on_active_job_id"
    t.index ["concurrency_key"], name: "index_good_jobs_on_concurrency_key_when_unfinished", where: "(finished_at IS NULL)"
    t.index ["cron_key", "created_at"], name: "index_good_jobs_on_cron_key_and_created_at"
    t.index ["cron_key", "cron_at"], name: "index_good_jobs_on_cron_key_and_cron_at", unique: true
    t.index ["finished_at"], name: "index_good_jobs_jobs_on_finished_at", where: "((retried_good_job_id IS NULL) AND (finished_at IS NOT NULL))"
    t.index ["priority", "created_at"], name: "index_good_jobs_jobs_on_priority_created_at_when_unfinished", order: { priority: "DESC NULLS LAST" }, where: "(finished_at IS NULL)"
    t.index ["queue_name", "scheduled_at"], name: "index_good_jobs_on_queue_name_and_scheduled_at", where: "(finished_at IS NULL)"
    t.index ["scheduled_at"], name: "index_good_jobs_on_scheduled_at", where: "(finished_at IS NULL)"
  end

  create_table "imports", force: :cascade do |t|
    t.string "title", null: false
    t.string "import_type"
    t.bigint "user_id"
    t.boolean "approved"
    t.bigint "approved_by_id"
    t.text "log"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "aasm_state"
    t.boolean "xlsx_valid"
    t.text "reason"
    t.index ["approved_by_id"], name: "index_imports_on_approved_by_id"
    t.index ["user_id"], name: "index_imports_on_user_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "name"
    t.string "lat"
    t.string "lon"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.geography "lonlat", limit: {:srid=>4326, :type=>"st_point", :geographic=>true}
    t.index ["lonlat"], name: "index_locations_on_lonlat", using: :gist
  end

  create_table "longhurst_provinces", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["code"], name: "index_longhurst_provinces_on_code"
  end

  create_table "marine_ecoregions_worlds", force: :cascade do |t|
    t.string "region_type", null: false
    t.string "province", null: false
    t.integer "trend_reg_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "marine_ecoregions_worlds_trends", id: false, force: :cascade do |t|
    t.bigint "marine_ecoregions_world_id", null: false
    t.bigint "trend_id", null: false
    t.index ["marine_ecoregions_world_id", "trend_id"], name: "marine_ecoregions_worlds_trends_index"
    t.index ["trend_id", "marine_ecoregions_world_id"], name: "trends_marine_ecoregions_worlds_index"
  end

  create_table "measurement_methods", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "trait_class_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["trait_class_id"], name: "index_measurement_methods_on_trait_class_id"
  end

  create_table "measurement_models", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "trait_class_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
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
    t.boolean "validated", null: false
    t.text "notes"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "validation_type_id"
    t.bigint "location_id", null: false
    t.bigint "longhurst_province_id"
    t.string "date"
    t.bigint "species_id", null: false
    t.index ["location_id"], name: "index_measurements_on_location_id"
    t.index ["longhurst_province_id"], name: "index_measurements_on_longhurst_province_id"
    t.index ["measurement_method_id"], name: "index_measurements_on_measurement_method_id"
    t.index ["measurement_model_id"], name: "index_measurements_on_measurement_model_id"
    t.index ["observation_id"], name: "index_measurements_on_observation_id"
    t.index ["precision_type_id"], name: "index_measurements_on_precision_type_id"
    t.index ["sex_type_id"], name: "index_measurements_on_sex_type_id"
    t.index ["species_id"], name: "index_measurements_on_species_id"
    t.index ["standard_id"], name: "index_measurements_on_standard_id"
    t.index ["trait_class_id"], name: "index_measurements_on_trait_class_id"
    t.index ["trait_id"], name: "index_measurements_on_trait_id"
    t.index ["validation_type_id"], name: "index_measurements_on_validation_type_id"
    t.index ["value_type_id"], name: "index_measurements_on_value_type_id"
  end

  create_table "observations", force: :cascade do |t|
    t.string "access"
    t.boolean "hidden"
    t.bigint "user_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "contributor_id"
    t.string "depth"
    t.bigint "import_id"
    t.index ["import_id"], name: "index_observations_on_import_id"
    t.index ["user_id"], name: "index_observations_on_user_id"
  end

  create_table "observations_references", id: false, force: :cascade do |t|
    t.bigint "observation_id", null: false
    t.bigint "reference_id", null: false
    t.index ["observation_id", "reference_id"], name: "index_obser_refs_on_observation_id_and_reference_id"
    t.index ["reference_id", "observation_id"], name: "index_obser_refs_on_reference_id_and_observation_id"
  end

  create_table "oceans", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "oceans_trends", id: false, force: :cascade do |t|
    t.bigint "trend_id", null: false
    t.bigint "ocean_id", null: false
    t.index ["ocean_id", "trend_id"], name: "index_oceans_trends_on_ocean_id_and_trend_id"
    t.index ["trend_id", "ocean_id"], name: "index_oceans_trends_on_trend_id_and_ocean_id"
  end

  create_table "precision_types", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "references", force: :cascade do |t|
    t.string "name", null: false
    t.string "doi"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "data_source"
    t.string "year"
    t.string "suffix"
    t.string "author_year"
    t.string "reference"
    t.boolean "file_public"
    t.string "slug", null: false
    t.index ["name"], name: "index_references_on_name", unique: true
    t.index ["slug"], name: "index_references_on_slug"
  end

  create_table "sampling_methods", force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "sex_types", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "source_observations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "source_observations_trends", id: false, force: :cascade do |t|
    t.bigint "trend_id", null: false
    t.bigint "source_observation_id", null: false
    t.index ["source_observation_id", "trend_id"], name: "source_observations_trends_index"
    t.index ["trend_id", "source_observation_id"], name: "trends_source_observations_index"
  end

  create_table "species", force: :cascade do |t|
    t.string "name", null: false
    t.string "iucn_code"
    t.bigint "species_superorder_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "species_data_type_id"
    t.bigint "species_subclass_id"
    t.bigint "species_order_id"
    t.bigint "species_family_id"
    t.string "edge_scientific_name"
    t.string "scientific_name"
    t.string "authorship"
    t.string "slug", null: false
    t.integer "cites_status", default: 0
    t.integer "cms_status", default: 0
    t.string "cms_status_year"
    t.string "cites_status_year"
    t.index ["slug"], name: "index_species_on_slug"
    t.index ["species_data_type_id"], name: "index_species_on_species_data_type_id"
    t.index ["species_family_id"], name: "index_species_on_species_family_id"
    t.index ["species_order_id"], name: "index_species_on_species_order_id"
    t.index ["species_subclass_id"], name: "index_species_on_species_subclass_id"
    t.index ["species_superorder_id"], name: "index_species_on_species_superorder_id"
  end

  create_table "species_data_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "species_families", force: :cascade do |t|
    t.string "name"
    t.bigint "species_subclass_id"
    t.bigint "species_superorder_id"
    t.bigint "species_order_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["species_order_id"], name: "index_species_families_on_species_order_id"
    t.index ["species_subclass_id"], name: "index_species_families_on_species_subclass_id"
    t.index ["species_superorder_id"], name: "index_species_families_on_species_superorder_id"
  end

  create_table "species_groups", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "species_orders", force: :cascade do |t|
    t.string "name"
    t.bigint "species_superorder_id"
    t.bigint "species_subclass_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["species_subclass_id"], name: "index_species_orders_on_species_subclass_id"
    t.index ["species_superorder_id"], name: "index_species_orders_on_species_superorder_id"
  end

  create_table "species_species_groups", id: false, force: :cascade do |t|
    t.bigint "species_id", null: false
    t.bigint "species_group_id", null: false
    t.index ["species_group_id", "species_id"], name: "index_species_species_groups_on_species_group_id_and_species_id"
    t.index ["species_id", "species_group_id"], name: "index_species_species_groups_on_species_id_and_species_group_id"
  end

  create_table "species_subclasses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "species_superorders", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "species_subclass_id"
    t.index ["species_subclass_id"], name: "index_species_superorders_on_species_subclass_id"
  end

  create_table "standards", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "trait_class_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["trait_class_id"], name: "index_standards_on_trait_class_id"
  end

  create_table "trait_classes", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "traits", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.bigint "trait_class_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["trait_class_id"], name: "index_traits_on_trait_class_id"
  end

  create_table "trend_observations", force: :cascade do |t|
    t.bigint "trend_id"
    t.string "year", null: false
    t.string "value", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["trend_id"], name: "index_trend_observations_on_trend_id"
  end

  create_table "trends", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "species_id"
    t.bigint "location_id"
    t.bigint "data_type_id"
    t.bigint "sampling_method_id"
    t.integer "no_years"
    t.integer "time_min"
    t.text "comments"
    t.string "page_and_figure_number"
    t.string "line_used"
    t.integer "pdf_page"
    t.integer "actual_page"
    t.string "depth"
    t.string "figure_name"
    t.string "figure_data"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.bigint "reference_id"
    t.bigint "standard_id"
    t.integer "start_year"
    t.integer "end_year"
    t.bigint "import_id"
    t.bigint "species_group_id"
    t.text "unit_freeform"
    t.string "sampling_method_info"
    t.string "dataset_representativeness_experts"
    t.string "experts_for_representativeness"
    t.boolean "dataset_map"
    t.boolean "variance"
    t.boolean "data_mined"
    t.bigint "unit_time_id"
    t.bigint "unit_spatial_id"
    t.bigint "unit_gear_id"
    t.bigint "unit_transformation_id"
    t.bigint "analysis_model_id"
    t.index ["analysis_model_id"], name: "index_trends_on_analysis_model_id"
    t.index ["data_type_id"], name: "index_trends_on_data_type_id"
    t.index ["import_id"], name: "index_trends_on_import_id"
    t.index ["location_id"], name: "index_trends_on_location_id"
    t.index ["reference_id"], name: "index_trends_on_reference_id"
    t.index ["sampling_method_id"], name: "index_trends_on_sampling_method_id"
    t.index ["species_group_id"], name: "index_trends_on_species_group_id"
    t.index ["species_id"], name: "index_trends_on_species_id"
    t.index ["standard_id"], name: "index_trends_on_standard_id"
    t.index ["unit_gear_id"], name: "index_trends_on_unit_gear_id"
    t.index ["unit_spatial_id"], name: "index_trends_on_unit_spatial_id"
    t.index ["unit_time_id"], name: "index_trends_on_unit_time_id"
    t.index ["unit_transformation_id"], name: "index_trends_on_unit_transformation_id"
    t.index ["user_id"], name: "index_trends_on_user_id"
  end

  create_table "unit_gears", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unit_spatials", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unit_times", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "unit_transformations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: nil
    t.datetime "remember_created_at", precision: nil
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.datetime "confirmation_sent_at", precision: nil
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "user_level", default: "user"
    t.string "name"
    t.string "token"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["token"], name: "index_users_on_token", unique: true
  end

  create_table "validation_types", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "value_types", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at", precision: nil
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "fao_areas", "oceans"
  add_foreign_key "imports", "users"
  add_foreign_key "imports", "users", column: "approved_by_id"
  add_foreign_key "measurement_methods", "trait_classes"
  add_foreign_key "measurement_models", "trait_classes"
  add_foreign_key "measurements", "locations"
  add_foreign_key "measurements", "longhurst_provinces"
  add_foreign_key "measurements", "measurement_methods"
  add_foreign_key "measurements", "measurement_models"
  add_foreign_key "measurements", "observations"
  add_foreign_key "measurements", "precision_types"
  add_foreign_key "measurements", "sex_types"
  add_foreign_key "measurements", "species"
  add_foreign_key "measurements", "standards"
  add_foreign_key "measurements", "trait_classes"
  add_foreign_key "measurements", "traits"
  add_foreign_key "measurements", "validation_types"
  add_foreign_key "measurements", "value_types"
  add_foreign_key "observations", "imports"
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
  add_foreign_key "trends", "\"references\"", column: "reference_id"
  add_foreign_key "trends", "analysis_models"
  add_foreign_key "trends", "data_types"
  add_foreign_key "trends", "imports"
  add_foreign_key "trends", "locations"
  add_foreign_key "trends", "sampling_methods"
  add_foreign_key "trends", "species"
  add_foreign_key "trends", "species_groups"
  add_foreign_key "trends", "standards"
  add_foreign_key "trends", "unit_gears"
  add_foreign_key "trends", "unit_spatials"
  add_foreign_key "trends", "unit_times"
  add_foreign_key "trends", "unit_transformations"
  add_foreign_key "trends", "users"
end
