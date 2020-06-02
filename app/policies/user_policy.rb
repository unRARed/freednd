class UserPolicy < ApplicationPolicy
  def sign_up?
    create?
  end

  def create?
    true
  end

  def account?
    user.present?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
