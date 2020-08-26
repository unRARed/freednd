class AddQuantityToProgressionItems < ActiveRecord::Migration[6.0]
  def change
    add_column :progression_items, :quantity, :integer
  end
end
