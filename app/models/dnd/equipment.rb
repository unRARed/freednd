require "sti_preload"

class DnD::Equipment < ApplicationRecord
  include StiPreload

  belongs_to :dnd_equipment_category, optional: true,
    class_name: 'DnD::EquipmentCategory'

  has_many :contained_equipment,
    :primary_key => :contents,
    :foreign_key => :id,
    :class_name => 'DnD::Equipment'

  def simple?
    return false unless ['Adventuring Gear', 'Armor'].
      include? self.dnd_equipment_category&.name
    return false if self.contained_equipment.any?
    self.description.blank?
  end

  def weapon?
    self.class.name == 'DnD::Weapon'
  end
end
