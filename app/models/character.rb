class Character < ApplicationRecord
  belongs_to :user

  has_many :progressions
end
