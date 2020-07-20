class CampaignPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    edit? || @record.users.include?(user)
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
    user.present? && @record.user == user
  end

  def destroy?
    edit?
  end

  def join?
    create?
  end

  class Scope < Scope
    def resolve
      scope
    end
  end
end
