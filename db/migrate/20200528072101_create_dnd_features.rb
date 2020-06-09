class CreateDnDFeatures < ActiveRecord::Migration[6.0]
  def change
    create_table :dnd_features do |t|
      t.string :name
      t.string :slug
      t.integer :level
      t.string :dnd_class_name
      t.string :description

      t.timestamps
    end
  end
end
