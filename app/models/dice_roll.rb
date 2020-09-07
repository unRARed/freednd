class DiceRoll < ApplicationRecord
  SupportedDice = [ 4, 6, 8, 10, 12, 20 ]

  belongs_to :campaign, optional: true
  belongs_to :progression, optional: true

  after_create_commit :broadcast_result

  before_create :generate_result

private

  def generate_result
    self.result = GamesDice.create(self.query).roll
  end

  def broadcast_result
    DiceRollBroadcastJob.perform_later(self)
  end
end
