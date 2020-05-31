class ApplicationController < ActionController::Base
  include Clearance::Controller

  include Pundit
  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

private

  def user_not_authorized
    flash[:danger] = 'That doesn’t appear to belong to you.'
    redirect_to(request.referrer || root_path)
  end
end
