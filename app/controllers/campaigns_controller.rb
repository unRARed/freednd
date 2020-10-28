class CampaignsController < ApplicationController
  include CharactersHelper

  SupportedDice = [4, 6, 8, 10, 12, 20]

  before_action :set_campaign,
    only: [:show, :edit, :update, :destroy, :join, :roll_dice]

  # GET /campaigns
  def index
    @campaigns = policy_scope(Campaign.is_open)
    return redirect_to(
      sign_in_path,
      flash: { danger: 'You need to be signed in to do that.' }
    ) unless signed_in?
  end

  # GET /campaigns/new
  def new
    @campaign = Campaign.new
    authorize(@campaign)
  end

  def create
    @campaign = Campaign.new(campaign_params)
    authorize(@campaign)
    @campaign.user = current_user
    return render :new unless @campaign.save
    redirect_to account_path,
      notice: 'Campaign was successfully created.'
  end

  def update
    authorize(@campaign)
    return render :show unless @campaign.update(campaign_params)
    redirect_to campaign_path(@campaign),
      notice: 'Campaign was successfully updated.'
  end

  def destroy
    @campaign.destroy
    redirect_to account_url,
      notice: 'Campaign was successfully destroyed.'
  end

  def join
    return redirect_to(
      campaigns_url,
      notice: 'Campaign is not open for joining.'
    ) if @campaign.is_locked?
    character = Character.find(params[:character_id])
    return redirect_to(
      campaigns_url,
      notice: 'That character doesn’t appear to belong to you.'
    ) unless current_user.characters.include? character

    # should be good to go
    unless party = @campaign.party
      party = Party.create! campaign: @campaign
    end
    party.progressions.create! character: character
    redirect_to @campaign,
      notice: "#{character.name} successfully joined #{@campaign.name}."
  end

private

    def set_campaign
      @campaign = Campaign.find(params[:id])
      authorize(@campaign)
    end

    def campaign_params
      params.require(:campaign).
        permit(
          :name,
          :description,
          :decoration,
          :notes,
          :is_locked
        )
    end
end
