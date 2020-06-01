class CharacterPolicy < ApplicationPolicy
  def index?
    false
  end

  def show?
    edit?
  end

  def create?
    user&.present?
  end

  def new?
    create?
  end

  def update?
    edit?
  end

  def edit?
    user.present? && @record.user == user
  end

  def destroy?
    edit?
  end

  def edit_content_field?
    edit?
  end

  class Scope < Scope
    def resolve
      scope.where(user: @user)
    end
  end
end
