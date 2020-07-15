class CreateProgressionItems < ActiveRecord::Migration[6.0]
  def change
    # Generic "join model" of a Characters Progression
    # to Spells, Features, Equipment, etc.
    create_table :progression_items do |t|
      t.belongs_to :progression, index: true, foreign_key: true
      t.belongs_to :skill,
        index: true, foreign_key: { to_table: :statistics }
      t.belongs_to :saving_throw,
        index: true, foreign_key: { to_table: :statistics }

      t.belongs_to :dnd_spell, index: true, foreign_key: true
      t.belongs_to :dnd_feature, index: true, foreign_key: true
      t.belongs_to :dnd_equipment, index: true, foreign_key: true
      t.timestamps
    end
  end
end
