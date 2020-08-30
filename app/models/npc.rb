class NPC < ApplicationRecord
  belongs_to :campaign

  validates :name, :location,
    presence: true

  has_one_attached :avatar

  has_rich_text :profile
end
