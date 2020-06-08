class CreateDnDFeatures < ActiveRecord::Migration[6.0]
  def change
    create_table :dnd_features do |t|
      t.string :name
      t.integer :level
      t.string :dnd_class
      t.string :description

      t.timestamps
    end
  end
end
