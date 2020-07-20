class RemoveRpFieldsFromCharacters < ActiveRecord::Migration[6.0]
  def change
    remove_column :characters, :appearance
    remove_column :characters, :backstory
    remove_column :characters, :personality
    remove_column :characters, :ideals
    remove_column :characters, :bonds
    remove_column :characters, :flaws
    remove_column :characters, :other_traits
  end
end
