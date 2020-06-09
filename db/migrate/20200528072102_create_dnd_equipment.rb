class CreateDnDEquipment < ActiveRecord::Migration[6.0]
  def change
    create_table :dnd_equipment do |t|
      t.string :type # STI armor / weapon
      t.string :name
      t.string :slug
      t.integer :weight
      t.string :cost_unit
      t.integer :cost_quantity
      t.string :description
      t.integer :dnd_equipment_category_id

      # armor fields
      t.string :armor_category
      t.integer :armor
      t.boolean :armor_awards_dex_bonus
      t.boolean :armor_has_stealth_disadvantage
      t.integer :armor_strength_minimum
      t.integer :armor_bonus_maximum

      # weapon fields
      t.string :weapon_category
      t.string :weapon_damage_die
      t.string :weapon_damage_bonus
      t.integer :weapon_range_normal
      t.integer :weapon_range_long
      t.integer :dnd_weapon_damage_type_id

      # weapon properties?
      t.timestamps
    end
  end
end
