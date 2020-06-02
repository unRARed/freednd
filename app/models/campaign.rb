class Campaign < ApplicationRecord
  belongs_to :user
  has_one :party
  has_many :progressions,
    :through => :party
  has_many :characters,
    -> { distinct },
    :through => :progressions
  has_many :users,
    -> { distinct },
    :through => :characters

  scope :is_open,
    -> { where(is_locked: false) }

  validates :name,
    presence: true
end
