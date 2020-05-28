class Party < ApplicationRecord
  belongs_to :campaign

  has_many :progressions
end
