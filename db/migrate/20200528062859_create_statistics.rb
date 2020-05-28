class CreateStatistics < ActiveRecord::Migration[5.2]
  def change
    create_table :statistics do |t|
      # STI for Skills and SavingThrows
      t.string :type
      t.string :name
      t.string :value
      t.boolean :is_proficient, default: false, null: false
      t.belongs_to :progression, index: true, foreign_key: true

      t.timestamps
    end
  end
end
