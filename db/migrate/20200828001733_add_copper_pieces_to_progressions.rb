class AddCopperPiecesToProgressions < ActiveRecord::Migration[6.0]
  def change
    add_column :progressions, :copper_pieces, :integer
  end
end
