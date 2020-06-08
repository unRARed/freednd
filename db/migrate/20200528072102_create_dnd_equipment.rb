class CreateDnDEquipment < ActiveRecord::Migration[6.0]
  def change
    create_table :dnd_equipment do |t|
      t.string :name
      t.string :variety
      t.integer :weight
      t.string :description

      t.timestamps
    end
  end
end
