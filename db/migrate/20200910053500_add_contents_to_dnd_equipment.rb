class AddContentsToDnDEquipment < ActiveRecord::Migration[6.0]
  def change
    add_column :dnd_equipment, :contents, :integer,
      array: true, default: []
  end
end
