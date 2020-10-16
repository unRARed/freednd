class DnD::Feature < ApplicationRecord
  scope :by_dnd_class,-> (dnd_class) {
    where(dnd_class_name: dnd_class.downcase).
    order('dnd_class_name ASC')
  }
  scope :by_level, -> { order('level ASC') }
end
