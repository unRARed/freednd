class CreateDiceRolls < ActiveRecord::Migration[6.0]
  def change
    create_table :dice_rolls do |t|
      t.references :campaign, foreign_key: true
      t.references :progression, foreign_key: true
      t.string :query
      t.integer :result

      t.timestamps
    end
  end
end
