class CreateSpells < ActiveRecord::Migration[6.0]
  def change
    create_table :spells do |t|
      t.string :name
      t.string :slug
      t.string :description
      t.integer :level
      t.string :level_conditions # dnd5eapi: "higher_level"
      t.string :dnd_classes
      t.string :school
      t.string :casting_time
      t.string :range
      t.string :components
      t.string :material
      t.string :duration
      t.boolean :is_ritual
      t.boolean :requires_concentration

      t.timestamps
    end
  end
end
