class CreateGameMasters < ActiveRecord::Migration[6.0]
  def change
    create_table :game_masters do |t|
      t.references :user, null: false, foreign_key: true
      t.references :campaign, null: false, foreign_key: true

      t.timestamps
    end
  end
end
