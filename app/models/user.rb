class User < ApplicationRecord
  include Clearance::User
  has_many :campaigns
  has_many :characters
  has_many :progressions,
    :through => :characters
  has_many :parties,
    :through => :progressions
  has_many :character_campaigns,
    -> { distinct },
    :through => :parties,
    :source => :campaign
  has_many :available_characters,
    -> {
      distinct.
      joins('
        LEFT OUTER JOIN progressions
          ON progressions.character_id = characters.id
      ').
      where('progressions.party_id': nil)
    },
    class_name: 'Character'
end
