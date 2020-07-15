require "sti_preload"

class Statistic < ApplicationRecord
  include StiPreload
  belongs_to :progression

  validates :name, :value,
    presence: true

  validates :value, numericality: { only_integer: true }

  validates :name, uniqueness: {
    scope: :progression_id,
    message: 'can be referenced only once per Character Progression.' }
end
