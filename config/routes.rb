Rails.application.routes.draw do
  root 'landing_pages#index'
  get 'license' => 'landing_pages#license'

  resources :characters
  get 'characters/:id/rp/:field' => 'characters#edit_content_field',
    as: 'edit_character_content_field'

  ###################
  ## User Sessions ##
  ###################
  resources :passwords,
    controller: "clearance/passwords", only: [:create, :new]
  resource :session,
    controller: "clearance/sessions", only: [:new, :create]
  get 'session' => redirect('sign_in')

  resources(:users,
    controller: "clearance/users",
    only: [:new, :create]
  ) do
    resource :password,
      controller: "clearance/passwords", only: [:edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "clearance/sessions#destroy", as: "sign_out"
  get "/sign_up" => "clearance/users#new", as: "sign_up"
end
