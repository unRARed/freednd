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
  has_many :spells, :through => :progression_items

  validates :character,
    :uniqueness => {
      :scope => :party,
      :message => 'may only exist once in the Party.'
    }

  after_validation :initialize_statistics

  accepts_nested_attributes_for :skills, :allow_destroy => true

  def level
    return explicit_level if explicit_level.present?
    case experience
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
    return 2 if 5 > level
    return 3 if 9 > level
    return 4 if 13 > level
    return 5 if 17 > level
    6
  end

  # ten plus wisdom mod
  #   (plus proficiency ONLY if proficient in perception)
  def passive_wisdom
    value = 10
    value += wisdom_mod&.to_i || 0
    value += proficiency_bonus if skills.
      find{|s| s.name == 'Perception'}&.is_proficient?
    value
  end

private

  def initialize_statistics
    if saving_throws.empty?
      SavingThrow.names.each do |_key, val|
        saving_throws.build name: val, value: 0
      end
    end
    if skills.empty?
      Skill.names.each do |_key, val|
        skills.build name: val, value: 0
      end
    end
  end
end
