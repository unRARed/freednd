class Statistic < ApplicationRecord
  belongs_to :progression

  validates :name, :value,
    presence: true

  validates :name, uniqueness: {
    scope: :progression_id,
    message: 'can be referenced only once per Character Progression.' }
end
