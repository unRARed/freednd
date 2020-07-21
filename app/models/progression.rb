# The "instance" of a particular Character’s progress
# within the scope of a particular Party.

class Progression < ApplicationRecord
  belongs_to :character
  belongs_to :party

  has_one :campaign,
    -> { distinct },
    :through => :party

  has_one :user,
    -> { distinct },
    :through => :character

  has_one :dungeon_master,
    -> { distinct },
    :through => :campaign,
    :source => :user

  # statistics
  has_many :skills
  has_many :saving_throws

  # assocated static content...
  # equipment, languages, spells, etc.
  has_many :progression_items
  has_many :features,
    -> { where.not(dnd_feature_id: nil) },
    class_name: 'ProgressionItem'
  has_many :spells,
    -> { where.not(dnd_spell_id: nil) },
    class_name: 'ProgressionItem'
  has_many :equipment,
    -> { where.not(dnd_equipment_id: nil) },
    class_name: 'ProgressionItem'

  has_many :dnd_cantrips, lambda {
      order(:level => :desc, :name => :asc).
      where('level = 0')
    },
    :through => :progression_items,
    :class_name => 'DnD::Spell',
    :source => :dnd_spell
  has_many :dnd_spells, lambda {
      order(:level => :desc, :name => :asc).
      where('level > 0')
    },
    :through => :progression_items
  has_many :dnd_features,
    -> { order(:level => :desc) },
    :through => :progression_items
  has_many :dnd_equipment,
    -> { order(:type => :asc) },
    :through => :progression_items,
    class_name: 'DnD::Equipment'
  has_many :dnd_armor,
    -> { order(:type => :asc) },
    :through => :progression_items,
    :class_name => 'DnD::Armor',
    :source => :dnd_equipment

  validates :character,
    :uniqueness => {
      :scope => :party,
      :message => 'may only exist once in the Party.'
    }

  after_validation :initialize_statistics

  accepts_nested_attributes_for :skills, :allow_destroy => true
  accepts_nested_attributes_for :saving_throws, :allow_destroy => true
  accepts_nested_attributes_for :progression_items, :allow_destroy => true
  accepts_nested_attributes_for :spells, :allow_destroy => true
  accepts_nested_attributes_for :features, :allow_destroy => true
  accepts_nested_attributes_for :equipment, :allow_destroy => true

  ABILITIES = [
    :strength,
    :dexterity,
    :constitution,
    :intelligence,
    :wisdom,
    :charisma
  ]

  ABILITIES.each do |ability|
    define_method(:"#{ability}_mod") do
      calculate_ability_mod(self.send(ability))
    end
  end

  def armor_class
    base = dnd_armor.any? ?
      dnd_armor.sum(:armor) : 10
    base + self.dexterity_mod.to_i
    # TODO - anything else to consider?
  end

  def spellcasting_modifier
    case self.character.dnd_class
    when 'Wizard'
      :intelligence_mod
    when *['Cleric', 'Druid', 'Ranger']
      :wisdom_mod
    when *['Bard', 'Paladin', 'Sorcerer', 'Warlock']
      :charisma_mod
    else
      nil
    end
  end

  def spell_save_dc
    return nil unless spellcasting_modifier
    self.send(spellcasting_modifier) + proficiency_bonus + 8
    # TODO - factor in any special modifiers
  end

  def spell_attack_mod
    self.proficiency_bonus + self.send(spellcasting_modifier)
  end

  def initiative_mod
    self.dexterity_mod.to_i
    # TODO - factor in class, race and features
  end

  def speed
    self.character.base_speed
    # TODO - factor in class, race and features
  end

  def proficiency_bonus
    case self.level
    when 0...4; 2
    when 5...8; 3
    when 9...12; 4
    when 13...16; 5
    else
      6
    end
    # TODO - base this on the dnd_class tables
  end

  def level
    return self.explicit_level if self.explicit_level.present?
    case self.experience
    when 0...300; 1
    when 300...900;	2
    when 900...2700; 3
    when 2700...6500;	4
    when 6500...14000; 5
    when 14000...23000; 6
    when 23000...34000; 7
    when 34000...48000;	8
    when 48000...64000;	9
    when 64000...85000;	10
    when 85000...100000; 11
    when 100000...120000;	12
    when 120000...140000;	13
    when 140000...165000;	14
    when 165000...195000;	15
    when 195000...225000;	16
    when 225000...265000;	17
    when 265000...305000;	18
    when 305000...355000;	19
    else 20
    end
  end

  def proficiency_bonus
    return 2 if 5 > self.level
    return 3 if 9 > self.level
    return 4 if 13 > self.level
    return 5 if 17 > self.level
    6
  end

  # ten plus wisdom mod
  #   (plus proficiency ONLY if proficient in perception)
  def passive_wisdom
    value = 10
    value += self.wisdom_mod&.to_i || 0
    value += self.proficiency_bonus if self.skills.
      find{|s| s.name == 'Perception'}&.is_proficient?
    value
  end

private

  def calculate_ability_mod(value)
    return 0 unless value || value == 0
    diff = value - 10
    return (diff.abs / 2) unless diff.negative?
    -(diff.abs / 2)
  end

  def initialize_statistics
    if self.saving_throws.empty?
      SavingThrow.names.each do |_key, val|
        self.saving_throws.build name: val, value: 0
      end
    end
    if self.skills.empty?
      Skill.names.each do |_key, val|
        self.skills.build name: val, value: 0
      end
    end
  end
end
