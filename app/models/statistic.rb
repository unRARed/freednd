class Statistic < ApplicationRecord
  belongs_to :progression

  validates :name, :value,
    presence: true

  validates :name, uniqueness: {
    scope: :character_id,
    message: 'can be referenced only once per Character.' }
end
