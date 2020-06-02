class UsersController < Clearance::UsersController
  def account
    authorize(User)
  end
end
