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

ActiveRecord::Schema[8.0].define(version: 2025_09_19_164545) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "ingredient_searches", force: :cascade do |t|
    t.text "ingredients"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "recipe_searches", force: :cascade do |t|
    t.text "ingredients"
        t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  ActiveRecord::Schema[8.0].define(version: 2025_09_20_151012) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "ingredients", force: :cascade do |t|
    t.string "provider_name"
    t.string "provider_id"
    t.string "title"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["provider_name", "provider_id"], name: "index_ingredients_on_provider_name_and_provider_id", unique: true
  end

  create_table "user_accounts", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.string "auth_protocol"
    t.string "oauth2"
    t.string "provider"
    t.string "provider_account_id"
    t.string "access_token"
    t.string "token_type", default: "Bearer"
    t.string "scope"
    t.string "refresh_token"
    t.datetime "expires_at"
    t.index ["user_id"], name: "index_user_accounts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "first_name"
    t.string "last_name"
  end

  add_foreign_key "user_accounts", "users"
end
