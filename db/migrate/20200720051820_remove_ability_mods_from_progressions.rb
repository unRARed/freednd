class RemoveAbilityModsFromProgressions < ActiveRecord::Migration[6.0]
  def change
    remove_column :progressions, :strength_mod
    remove_column :progressions, :dexterity_mod
    remove_column :progressions, :constitution_mod
    remove_column :progressions, :intelligence_mod
    remove_column :progressions, :wisdom_mod
    remove_column :progressions, :charisma_mod
  end
end
