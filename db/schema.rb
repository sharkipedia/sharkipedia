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

ActiveRecord::Schema.define(version: 2019_02_08_001657) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "observations", force: :cascade do |t|
    t.bigint "resource_id"
    t.bigint "secondary_resource_id"
    t.bigint "species_id"
    t.bigint "longhurst_province_id"
    t.string "date"
    t.string "access"
    t.integer "hidden"
    t.bigint "user_id"
    t.bigint "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_observations_on_location_id"
    t.index ["longhurst_province_id"], name: "index_observations_on_longhurst_province_id"
    t.index ["resource_id"], name: "index_observations_on_resource_id"
    t.index ["secondary_resource_id"], name: "index_observations_on_secondary_resource_id"
    t.index ["species_id"], name: "index_observations_on_species_id"
    t.index ["user_id"], name: "index_observations_on_user_id"
  end

  create_table "resources", force: :cascade do |t|
    t.string "name", null: false
    t.string "doi", null: false
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
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "observations", "locations"
  add_foreign_key "observations", "longhurst_provinces"
  add_foreign_key "observations", "resources"
  add_foreign_key "observations", "species"
  add_foreign_key "observations", "users"
  add_foreign_key "traits", "trait_classes"
end
