class CampaignChannel < ApplicationCable::Channel
  def subscribed
    stream_from "campaign_#{params[:id]}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def save_and_broadcast_dice_roll(data)
    # TODO: pass the string to DiceRoll model
    DiceRoll.create(query: data['dice_roll_query'])
  end
end
