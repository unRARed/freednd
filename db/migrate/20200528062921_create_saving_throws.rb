class CreateSavingThrows < ActiveRecord::Migration[6.0]
  def change
    create_table :saving_throws do |t|

      t.timestamps
    end
  end
end
