class DnD::EquipmentCategory < DnD::Entity
  has_many :dnd_equipment,
    :class_name => '::DnD::Equipment',
    :foreign_key => :dnd_equipment_category_id
end
