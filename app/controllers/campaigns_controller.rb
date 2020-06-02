class CampaignsController < ApplicationController
  before_action :set_campaign,
    only: [:show, :edit, :update, :destroy, :join]

  # GET /campaigns
  def index
    @campaigns = policy_scope(Campaign.is_open)
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
    return render :show unless @campaign.update(campaign_params)
    redirect_to account_path,
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
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign
      @campaign = Campaign.find(params[:id])
      authorize(@campaign)
    end

    def campaign_params
      params.require(:campaign).
        permit(:name, :description, :is_locked)
    end
end