class NPCPolicy < ApplicationPolicy
  def create?
    is_dm?
  end

  def new?
    is_dm?
  end

  def update?
    is_dm?
  end

  def edit?
    is_dm?
  end

  def destroy?
    is_dm?
  end

private

  def is_dm?
    user.present? && @record.campaign.user == user
  end
end
