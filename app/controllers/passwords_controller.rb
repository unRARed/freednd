class PasswordsController < Clearance::PasswordsController
  skip_after_action :verify_authorized

  def new
    authorize(User)
  end

  # From https://github.com/thoughtbot/clearance/blob/\
  #   master/app/controllers/clearance/passwords_controller.rb#L21
  def edit
    @user = find_user_for_edit
    authorize(@user, policy_class: PasswordsPolicy)

    if params[:token]
      session[:password_reset_token] = params[:token]
      redirect_to url_for
    else
      render template: "passwords/edit"
    end
  end
end
