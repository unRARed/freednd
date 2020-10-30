class NPCPolicy < ApplicationPolicy
  def create?
    is_game_master?
  end

  def new?
    is_game_master?
  end

  def update?
    is_game_master?
  end

  def edit?
    is_game_master?
  end

  def destroy?
    is_game_master?
  end

private

  def is_game_master?
    user.present? && @record.campaign.game_masters.
      any?{|gm| gm.user == user}
  end
end
