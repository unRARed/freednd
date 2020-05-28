class CreateSpells < ActiveRecord::Migration[6.0]
  def change
    create_table :spells do |t|
      t.string :name
      t.string :slug
      t.string :description
      t.integer :level # Open5e API: "level_int"
      t.string :level_conditions # Open5e API: "higher_level"
      t.string :dnd_class
      t.string :school
      t.string :casting_time
      t.string :range
      t.string :components
      t.string :material
      t.string :duration
      t.string :reference # Open5e API: "page"
      t.boolean :is_ritual
      t.boolean :requires_concentration
      t.string :archetype
      t.string :circles

      t.timestamps
    end
  end
end
