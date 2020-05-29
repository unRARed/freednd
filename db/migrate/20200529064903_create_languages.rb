class CreateLanguages < ActiveRecord::Migration[6.0]
  def change
    create_table :languages do |t|
      t.string :name
      t.string :variety
      t.string :script
      t.string :dnd_races

      t.timestamps
    end
  end
end
