class UsersController < Clearance::UsersController
  def new
    @user = User.new
    authorize(@user)
  end

  def account
    authorize(User)
  end
end
