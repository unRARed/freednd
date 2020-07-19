require "sti_preload"

class DnD::Equipment < ApplicationRecord
  include StiPreload

  belongs_to :dnd_equipment_category, optional: true,
    class_name: 'DnD::EquipmentCategory'
end
