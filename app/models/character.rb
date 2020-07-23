class Character < ApplicationRecord
  belongs_to :user

  has_many :progressions
  has_many :parties,
    :through => :progressions
  has_many :campaigns,
    :through => :parties
  has_many :party_members,
    -> { distinct },
    :through => :parties,
    :source => :users

  has_one_attached :avatar

  ABILITIES = [
    :strength,
    :dexterity,
    :constitution,
    :intelligence,
    :wisdom,
    :charisma
  ]

  RP_FIELDS = [
    :appearance,
    :backstory,
    :personality,
    :ideals,
    :bonds,
    :flaws,
    :other_traits
  ]

  RP_FIELDS.each { |field| has_rich_text field }

  validates :alignment,
    :dnd_class,
    :race,
    :background,
    :name,
    presence: true

  validates :name,
    uniqueness: {
      :scope => :user_id,
      :message => 'was already used for another character you have.'
    }

  enum alignment: {
    'Lawful Good': 'Lawful Good',
    'Neutral Good': 'Neutral Good',
    'Chaotic Good': 'Chaotic Good',
    'Lawful Neutral': 'Lawful Neutral',
    'Neutral': 'Neutral',
    'Chaotic Neutral': 'Chaotic Neutral',
    'Lawful Evil': 'Lawful Evil',
    'Neutral Evil': 'Neutral Evil',
    'Chaotic Evil': 'Chaotic Evil'
  }

  enum dnd_class: {
    'Barbarian': 'Barbarian',
    'Bard': 'Bard',
    'Cleric': 'Cleric',
    'Druid': 'Druid',
    'Fighter': 'Fighter',
    'Wizard': 'Wizard',
    'Monk': 'Monk',
    'Paladin': 'Paladin',
    'Ranger': 'Ranger',
    'Sorcerer': 'Sorcerer',
    'Rogue': 'Rogue',
    'Warlock': 'Warlock'
  }

  enum race: {
    'Dragonborn': 'Dragonborn',
    'Dwarf': 'Dwarf',
    'Elf': 'Elf',
    'Gnome': 'Gnome',
    'Half-elf': 'Half-elf',
    'Half-orc': 'Half-orc',
    'Halfling': 'Halfling',
    'Human': 'Human',
    'Tiefling': 'Tiefling'
  }

  enum background: {
    'Acolyte': 'Acolyte',
    'Anthropologist': 'Anthropologist',
    'Archaeologist': 'Archaeologist',
    'Adopted': 'Adopted',
    'Black Fist Double Agent': 'Black Fist Double Agent',
    'Caravan Specialist': 'Caravan Specialist',
    'Charlatan': 'Charlatan',
    'City Watch': 'City Watch',
    'Clan Crafter': 'Clan Crafter',
    'Cloistered Scholar': 'Cloistered Scholar',
    'Cormanthor Refugee': 'Cormanthor Refugee',
    'Courtier': 'Courtier',
    'Criminal': 'Criminal',
    'Dissenter': 'Dissenter',
    'Dragon Casualty': 'Dragon Casualty',
    'Earthspur Miner': 'Earthspur Miner',
    'Entertainer': 'Entertainer',
    'Faction Agent': 'Faction Agent',
    'Far Traveler': 'Far Traveler',
    'Folk Hero': 'Folk Hero',
    'Gate Urchin': 'Gate Urchin',
    'Gladiator': 'Gladiator',
    'Guild Artisan': 'Guild Artisan',
    'Guild Merchant': 'Guild Merchant',
    'Harborfolk': 'Harborfolk',
    'Haunted One': 'Haunted One',
    'Hermit': 'Hermit',
    'Hillsfar Merchant': 'Hillsfar Merchant',
    'Hillsfar Smuggler': 'Hillsfar Smuggler',
    'House Agent': 'House Agent',
    'Inheritor': 'Inheritor',
    'Initiate': 'Initiate',
    'Inquisitor': 'Inquisitor',
    'Investigator': 'Investigator',
    'Iron Route Bandit': 'Iron Route Bandit',
    'Knight': 'Knight',
    'Knight of the Order': 'Knight of the Order',
    'Mercenary Veteran': 'Mercenary Veteran',
    'Mulmaster Aristocrat': 'Mulmaster Aristocrat',
    'Noble': 'Noble',
    'Outlander': 'Outlander',
    'Phlan Insurgent': 'Phlan Insurgent',
    'Phlan Refugee': 'Phlan Refugee',
    'Pirate': 'Pirate',
    'Sage': 'Sage',
    'Sailor': 'Sailor',
    'Secret Identity': 'Secret Identity',
    'Shade Fanatic': 'Shade Fanatic',
    'Soldier': 'Soldier',
    'Spy': 'Spy',
    'Student Of Magic': 'Student Of Magic',
    'Stojanow Prisoner': 'Stojanow Prisoner',
    'Ticklebelly Nomad': 'Ticklebelly Nomad',
    'Trade Sheriff': 'Trade Sheriff',
    'Urban Bounty Hunter': 'Urban Bounty Hunter',
    'Urchin': 'Urchin',
    'Uthgardt Tribe Member': 'Uthgardt Tribe Member',
    'Vizier': 'Vizier',
    'Waterdhavian Noble': 'Waterdhavian Noble'
  }

  (ABILITIES + [
    :explicit_level,
    :experience,
    :hit_points,
    :hit_points_max,
    :armor_class,
    :initiative,
    :speed,
    :inspiration
  ]).each do |ability|
    define_method(ability) do
      get_value_from_progression(ability)
    end
  end

  ABILITIES.each do |ability|
    define_method(:"#{ability}_mod") do
      get_value_from_progression("#{ability}_mod")
    end
  end

  def base_speed
    return 25 if ['Dwarf', 'Halfling', 'Gnome'].include? self.race
    30
  end

  def avatar_portrait
    avatar.variant(
      auto_orient: true,
      combine_options: {
        resize: '480x720^', gravity: 'center', extent: '480x720'
      }
    ).processed
  end

  def avatar_thumb
    avatar.variant(
      auto_orient: true,
      combine_options: {
        resize: '480x480^', gravity: 'center', extent: '480x480'
      }
    ).processed
  end

private

  def get_value_from_progression(key)
    return 0 unless progressions.any?
    progressions.last.send(key) || 0
  end
end
