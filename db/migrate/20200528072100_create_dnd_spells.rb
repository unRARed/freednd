class CreateDnDSpells < ActiveRecord::Migration[6.0]
  def change
    create_table :dnd_spells do |t|
      t.string :name
      t.string :slug
      t.string :description
      t.integer :level
      t.string :level_conditions # dnd5eapi: "higher_level"
      t.string :dnd_classes
      t.string :archetypes
      t.string :school
      t.string :casting_time
      t.string :range
      t.string :components
      t.string :material
      t.string :duration
      t.string :circles
      t.boolean :requires_concentration
      t.boolean :is_ritual

      t.timestamps
    end
  end
end
