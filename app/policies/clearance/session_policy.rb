class Clearance::SessionPolicy < ApplicationPolicy
  def sign_out?
    true
  end
  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
