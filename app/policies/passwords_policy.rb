class PasswordsPolicy < ApplicationPolicy
  def new?
    true
  end

  def create?
    new?
  end

  def edit?
    new?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
