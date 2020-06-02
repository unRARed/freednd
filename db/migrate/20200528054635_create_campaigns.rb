class CreateCampaigns < ActiveRecord::Migration[6.0]
  def change
    create_table :campaigns do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.string :name
      t.string :description
      t.boolean :is_locked

      t.timestamps
    end
  end
end
