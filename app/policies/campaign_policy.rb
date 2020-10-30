class CampaignPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    is_party_member?
  end

  def create?
    user&.present?
  end

  def new?
    create?
  end

  # only DM can edit/update
  def update?
    edit?
  end

  def edit?
    is_game_master?
  end

  def destroy?
    edit?
  end

  def join?
    create?
  end

  def add_game_master?
    # TODO: limit to game masters after dm is refactored to always be
    create?
  end

private

  def is_party_member?
    edit? || @record.users.include?(user)
  end

  def is_game_master?
    user.present? && @record.game_masters.any?{|gm| gm.user == user}
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
