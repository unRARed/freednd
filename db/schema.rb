# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_28_072312) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "campaigns", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_campaigns_on_user_id"
  end

  create_table "characters", force: :cascade do |t|
    t.string "name", null: false
    t.string "dnd_class", null: false
    t.string "race", null: false
    t.string "background", null: false
    t.string "alignment", null: false
    t.decimal "height", precision: 6, scale: 2
    t.decimal "weight", precision: 8, scale: 2
    t.integer "age"
    t.string "appearance"
    t.string "backstory"
    t.string "personality"
    t.string "allies"
    t.string "organizations"
    t.text "languages"
    t.text "ideals"
    t.text "bonds"
    t.text "flaws"
    t.text "other_traits"
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "parties", force: :cascade do |t|
    t.bigint "campaign_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["campaign_id"], name: "index_parties_on_campaign_id"
  end

  create_table "progression_items", force: :cascade do |t|
    t.bigint "progression_id"
    t.bigint "spell_id"
    t.bigint "skill_id"
    t.bigint "saving_throw_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["progression_id"], name: "index_progression_items_on_progression_id"
    t.index ["saving_throw_id"], name: "index_progression_items_on_saving_throw_id"
    t.index ["skill_id"], name: "index_progression_items_on_skill_id"
    t.index ["spell_id"], name: "index_progression_items_on_spell_id"
  end

  create_table "progressions", force: :cascade do |t|
    t.bigint "character_id"
    t.bigint "party_id"
    t.string "archetype"
    t.integer "experience", default: 0, null: false
    t.integer "hit_points", default: 0, null: false
    t.integer "hit_points_max", default: 300, null: false
    t.integer "armor_class"
    t.integer "initiative"
    t.integer "speed"
    t.integer "inspiration"
    t.integer "strength"
    t.integer "strength_mod"
    t.integer "dexterity"
    t.integer "dexterity_mod"
    t.integer "constitution"
    t.integer "constitution_mod"
    t.integer "intelligence"
    t.integer "intelligence_mod"
    t.integer "wisdom"
    t.integer "wisdom_mod"
    t.integer "charisma"
    t.integer "charisma_mod"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["character_id"], name: "index_progressions_on_character_id"
    t.index ["party_id"], name: "index_progressions_on_party_id"
  end

  create_table "saving_throws", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "skills", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "spells", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "description"
    t.integer "level"
    t.string "level_conditions"
    t.string "dnd_class"
    t.string "school"
    t.string "casting_time"
    t.string "range"
    t.string "components"
    t.string "material"
    t.string "duration"
    t.string "reference"
    t.boolean "is_ritual"
    t.boolean "requires_concentration"
    t.string "archetype"
    t.string "circles"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "statistics", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.string "value"
    t.boolean "is_proficient", default: false, null: false
    t.bigint "progression_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["progression_id"], name: "index_statistics_on_progression_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "encrypted_password", limit: 128
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  add_foreign_key "campaigns", "users"
  add_foreign_key "characters", "users"
  add_foreign_key "parties", "campaigns"
  add_foreign_key "progression_items", "progressions"
  add_foreign_key "progression_items", "spells"
  add_foreign_key "progression_items", "statistics", column: "saving_throw_id"
  add_foreign_key "progression_items", "statistics", column: "skill_id"
  add_foreign_key "progressions", "characters"
  add_foreign_key "progressions", "parties"
  add_foreign_key "statistics", "progressions"
end
