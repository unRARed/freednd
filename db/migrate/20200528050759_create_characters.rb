class CreateCharacters < ActiveRecord::Migration[6.0]
  def change
    create_table :characters do |t|
      t.string :name, null: false
      t.string :dnd_class, null: false
      t.string :race, null: false
      t.string :background, null: false
      t.string :alignment, null: false
      t.decimal :height, precision: 6, scale: 2
      t.decimal :weight, precision: 8, scale: 2
      t.integer :age
      t.string :appearance
      t.string :backstory
      t.string :personality
      t.string :allies
      t.string :organizations
      t.text :languages
      t.text :ideals
      t.text :bonds
      t.text :flaws
      t.text :other_traits
      t.belongs_to :user, index: true, foreign_key: true

      t.timestamps
    end
  end
end
