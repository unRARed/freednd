class NPCsController < ApplicationController
  before_action :set_npc,
    only: [:edit, :update, :destroy]

  def new
    @npc = NPC.new
    @npc.campaign = Campaign.find(params[:campaign_id])
    authorize(@npc)
  end

  def create
    @npc = NPC.new(npc_params)
    @npc.campaign = Campaign.find(params[:campaign_id])
    authorize(@npc)
    return render :new unless @npc.save
    redirect_to @npc.campaign,
      notice: 'NPC was successfully created.'
  end

  def update
    return render :edit unless @npc.update(npc_params)
    redirect_to @npc.campaign,
      notice: 'NPC was successfully updated.'
  end

  def destroy
    campaign = @npc.campaign
    return render 'campaigns/show' unless @npc.destroy!
    redirect_to campaign,
      notice: 'NPC was successfully removed.'
  end

private

    def set_npc
      @npc = NPC.find(params[:id])
      authorize(@npc)
    end

    def npc_params
      params.require(:npc).permit(
        :name,
        :location,
        :in_party,
        :is_male,
        :race,
        :avatar,
        :profile,
        :notes
      )
    end
end
