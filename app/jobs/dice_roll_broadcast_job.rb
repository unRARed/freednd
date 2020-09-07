class DiceRollBroadcastJob < ApplicationJob
  queue_as :default

  def perform(dice_roll)
    ActionCable.server.broadcast(
      "campaign_#{dice_roll.campaign_id}_channel",
      dice_roll: render_dice_roll(dice_roll)
    )
  end

private

  def render_dice_roll(dice_roll)
    # NOTE: will need to refactor this a bit to handle
    #       broadcasting to different channels
    CampaignsController.render partial: 'shared/dice_roll',
      locals: { dice_roll: dice_roll }
  end
end
