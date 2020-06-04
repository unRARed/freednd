class UsersController < Clearance::UsersController
  skip_after_action :verify_authorized, only: [:create]

  def new
    @user = User.new
    authorize(@user)
  end

  def account
    authorize(User)
  end
end
