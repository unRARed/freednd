class CreateNPCs < ActiveRecord::Migration[6.0]
  def change
    create_table :npcs do |t|
      t.belongs_to :campaign, index: true, foreign_key: true
      t.string :name, null: false
      t.string :location, null: false
      t.string :race
      t.boolean :in_party, default: false, null: false
      t.boolean :is_male, default: false, null: false

      t.timestamps
    end
  end
end
