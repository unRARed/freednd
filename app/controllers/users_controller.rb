class UsersController < Clearance::UsersController
  skip_after_action :verify_authorized, only: [:create]

  def new
    @user = User.new
    authorize(@user)
  end

  def account
    authorize(User)
    return redirect_to root_path unless current_user
    @campaigns = current_user.campaigns +
      current_user.character_campaigns
  end
end
