class DnD::Weapon < DnD::Equipment
  belongs_to :damage_type,
    optional: true,
    foreign_key: :dnd_weapon_damage_type_id,
    class_name: '::DnD::DamageType'
end
