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

ActiveRecord::Schema.define(version: 2020_10_30_072232) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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

  create_table "campaigns", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "description"
    t.boolean "is_locked"
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
    t.bigint "user_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_characters_on_user_id"
  end

  create_table "dice_rolls", force: :cascade do |t|
    t.bigint "campaign_id"
    t.bigint "progression_id"
    t.string "query"
    t.integer "result"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["campaign_id"], name: "index_dice_rolls_on_campaign_id"
    t.index ["progression_id"], name: "index_dice_rolls_on_progression_id"
  end

  create_table "dnd_entities", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.string "slug"
    t.string "description"
    t.integer "parent_entity_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dnd_equipment", force: :cascade do |t|
    t.string "type"
    t.string "name"
    t.string "slug"
    t.integer "weight"
    t.string "cost_unit"
    t.integer "cost_quantity"
    t.string "description"
    t.integer "dnd_equipment_category_id"
    t.string "armor_category"
    t.integer "armor"
    t.boolean "armor_awards_dex_bonus"
    t.boolean "armor_has_stealth_disadvantage"
    t.integer "armor_strength_minimum"
    t.integer "armor_bonus_maximum"
    t.string "weapon_category"
    t.string "weapon_damage_die"
    t.string "weapon_damage_bonus"
    t.integer "weapon_range_normal"
    t.integer "weapon_range_long"
    t.integer "dnd_weapon_damage_type_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "contents", default: [], array: true
  end

  create_table "dnd_features", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.integer "level"
    t.string "dnd_class_name"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dnd_proficiencies", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "category"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "dnd_spells", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "description"
    t.integer "level"
    t.string "level_conditions"
    t.string "dnd_classes"
    t.string "archetypes"
    t.string "school"
    t.string "casting_time"
    t.string "range"
    t.string "components"
    t.string "material"
    t.string "duration"
    t.string "circles"
    t.boolean "requires_concentration"
    t.boolean "is_ritual"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "game_masters", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "campaign_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["campaign_id"], name: "index_game_masters_on_campaign_id"
    t.index ["user_id"], name: "index_game_masters_on_user_id"
  end

  create_table "languages", force: :cascade do |t|
    t.string "name"
    t.string "variety"
    t.string "script"
    t.string "dnd_races"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "npcs", force: :cascade do |t|
    t.bigint "campaign_id"
    t.string "name", null: false
    t.string "location", null: false
    t.string "race"
    t.boolean "in_party", default: false, null: false
    t.boolean "is_male", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["campaign_id"], name: "index_npcs_on_campaign_id"
  end

  create_table "parties", force: :cascade do |t|
    t.bigint "campaign_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["campaign_id"], name: "index_parties_on_campaign_id"
  end

  create_table "progression_items", force: :cascade do |t|
    t.bigint "progression_id"
    t.bigint "dnd_spell_id"
    t.bigint "dnd_feature_id"
    t.bigint "dnd_equipment_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "quantity"
    t.index ["dnd_equipment_id"], name: "index_progression_items_on_dnd_equipment_id"
    t.index ["dnd_feature_id"], name: "index_progression_items_on_dnd_feature_id"
    t.index ["dnd_spell_id"], name: "index_progression_items_on_dnd_spell_id"
    t.index ["progression_id"], name: "index_progression_items_on_progression_id"
  end

  create_table "progressions", force: :cascade do |t|
    t.bigint "character_id"
    t.bigint "party_id"
    t.string "archetype"
    t.integer "explicit_level"
    t.integer "experience", default: 0, null: false
    t.integer "hit_points", default: 0, null: false
    t.integer "hit_points_max", default: 300, null: false
    t.integer "inspiration"
    t.integer "strength"
    t.integer "dexterity"
    t.integer "constitution"
    t.integer "intelligence"
    t.integer "wisdom"
    t.integer "charisma"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "copper_pieces"
    t.index ["character_id"], name: "index_progressions_on_character_id"
    t.index ["party_id"], name: "index_progressions_on_party_id"
  end

  create_table "races", force: :cascade do |t|
    t.string "name"
    t.integer "speed"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "campaigns", "users"
  add_foreign_key "characters", "users"
  add_foreign_key "dice_rolls", "campaigns"
  add_foreign_key "dice_rolls", "progressions"
  add_foreign_key "game_masters", "campaigns"
  add_foreign_key "game_masters", "users"
  add_foreign_key "npcs", "campaigns"
  add_foreign_key "parties", "campaigns"
  add_foreign_key "progression_items", "dnd_equipment", column: "dnd_equipment_id"
  add_foreign_key "progression_items", "dnd_features"
  add_foreign_key "progression_items", "dnd_spells"
  add_foreign_key "progression_items", "progressions"
  add_foreign_key "progressions", "characters"
  add_foreign_key "progressions", "parties"
  add_foreign_key "statistics", "progressions"
end
