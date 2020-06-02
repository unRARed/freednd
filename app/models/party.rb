class Party < ApplicationRecord
  belongs_to :campaign

  has_many :progressions
  has_many :characters,
    :through => :progressions
  has_many :users,
    :through => :characters
end
