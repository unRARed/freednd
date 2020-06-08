class DnD::Skill < DnD::Entity
  belongs_to :dnd_ability,
    :foreign_key => :parent_entity_id,
    :class_name => 'DnD::Ability'
end
