class CreateDnDProficiencies < ActiveRecord::Migration[6.0]
  def change
    create_table :dnd_proficiencies do |t|
      t.string :name
      t.string :slug
      t.string :category

      t.timestamps
    end
  end
end
