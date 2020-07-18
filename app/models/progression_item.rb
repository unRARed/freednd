class ProgressionItem < ApplicationRecord
  belongs_to :progression

  belongs_to :dnd_spell,
    optional: true,
    class_name: 'DnD::Spell'
  belongs_to :dnd_feature,
    optional: true,
    class_name: 'DnD::Feature'
end
