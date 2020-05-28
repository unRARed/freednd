class Campaign < ApplicationRecord
  belongs_to :user
  has_one :party
end
