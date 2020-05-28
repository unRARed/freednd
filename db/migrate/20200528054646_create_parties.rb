class CreateParties < ActiveRecord::Migration[6.0]
  def change
    create_table :parties do |t|
      t.belongs_to :campaign, index: true, foreign_key: true

      t.timestamps
    end
  end
end
