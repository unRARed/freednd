class DnD::DamageType < DnD::Entity
  has_one :dnd_weapon,
    class_name: 'DnD::Weapon'
end
