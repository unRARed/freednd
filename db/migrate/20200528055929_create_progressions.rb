class CreateProgressions < ActiveRecord::Migration[6.0]
  def change
    create_table :progressions do |t|
      t.belongs_to :character, index: true, foreign_key: true
      t.belongs_to :party, index: true, foreign_key: true
      t.string :archetype
      t.integer :experience, null: false, default: 0
      t.integer :hit_points, null: false, default: 0
      t.integer :hit_points_max, null: false, default: 300
      t.integer :armor_class
      t.integer :initiative
      t.integer :speed
      t.integer :inspiration

      # abilities
      t.integer :strength
      t.integer :strength_mod
      t.integer :dexterity
      t.integer :dexterity_mod
      t.integer :constitution
      t.integer :constitution_mod
      t.integer :intelligence
      t.integer :intelligence_mod
      t.integer :wisdom
      t.integer :wisdom_mod
      t.integer :charisma
      t.integer :charisma_mod

      t.timestamps
    end
  end
end
