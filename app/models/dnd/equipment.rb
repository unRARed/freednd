require "sti_preload"

class DnD::Equipment < ApplicationRecord
  include StiPreload

  belongs_to :dnd_equipment_category, optional: true,
    class_name: 'DnD::EquipmentCategory'

  def simple?
    return false unless ['Adventuring Gear', 'Armor'].
      include? self.dnd_equipment_category&.name
    self.description.blank?
  end

  def weapon?
    self.class.name == 'DnD::Weapon'
  end
end
