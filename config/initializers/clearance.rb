Clearance.configure do |config|
  config.routes = false
  config.mailer_sender = "noreply@freednd.com"
  config.rotate_csrf_on_sign_in = true

  ########################
  ## Clearance Defaults ##
  ########################
  #config.allow_sign_up = true
  #config.cookie_expiration = lambda { |cookies| 1.year.from_now.utc }
  #config.cookie_name = "remember_token"
  # this one will break things in set and unmatched...
  #config.cookie_domain = '.example.com'
  #config.cookie_path = "/"
  #config.routes = true
  #config.httponly = false
  #config.password_strategy = Clearance::PasswordStrategies::BCrypt
  #config.redirect_url = "/"
  #config.secure_cookie = false
  #config.sign_in_guards = []
  #config.user_model = "User"
  #config.parent_controller = "ApplicationController"
end

Rails.application.config.to_prepare do
  Clearance::SessionsController.class_eval do
    before_action :skip_authorization
    before_action :skip_policy_scope
    skip_after_action :verify_authorized
    after_action :verify_policy_scoped
  end
end
