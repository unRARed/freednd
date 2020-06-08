class CreateDnDEntities < ActiveRecord::Migration[6.0]
  def change
    create_table :dnd_entities do |t|
      t.string :type
      t.string :name
      t.string :slug
      t.string :description
      t.integer :parent_entity_id

      t.timestamps
    end
  end
end
