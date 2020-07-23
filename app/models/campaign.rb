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

  has_one_attached :decoration

  scope :is_open,
    -> { where(is_locked: false) }

  validates :name,
    presence: true

  def decoration_thumb
    decoration.variant(
      auto_orient: true,
      combine_options: {
        resize: '480x480^', gravity: 'center', extent: '480x480'
      }
    ).processed
  end

end
