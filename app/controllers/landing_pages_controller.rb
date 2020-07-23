class LandingPagesController < ApplicationController
  before_action :skip_authorization
  before_action :skip_policy_scope
  skip_after_action :verify_authorized
  after_action :verify_policy_scoped

  def index
    redirect_to account_path if current_user
  end
end
