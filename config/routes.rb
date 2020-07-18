Rails.application.routes.draw do
  root 'landing_pages#index'
  get 'license' => 'landing_pages#license'

  resources :characters
  get 'characters/:id/rp/:field' => 'characters#edit_content_field',
    as: 'edit_character_content_field'

  resources :campaigns
  resources :progressions, only: [:update]
  get 'campaigns/:campaign_id/progressions/:id/abilities' =>
    'progressions#edit_abilities',
    as: 'edit_campaign_progression_abilities'
  get 'campaigns/:campaign_id/progressions/:id/status' =>
    'progressions#edit_status',
    as: 'edit_campaign_progression_status'
  get 'campaigns/:campaign_id/progressions/:id/skills' =>
    'progressions#edit_skills',
    as: 'edit_campaign_progression_skills'
  get 'campaigns/:campaign_id/progressions/:id/saving_throws' =>
    'progressions#edit_saving_throws',
    as: 'edit_campaign_progression_saving_throws'
  get 'campaigns/:campaign_id/progressions/:id/spells' =>
    'progressions#edit_spells',
    as: 'edit_campaign_progression_spells'
  post 'campaigns/:id/join' => 'campaigns#join',
    as: 'join_campaign'

  delete 'campaigns/:campaign_id/' +
    'progressions/:progression_id/' +
    'progression_items/:id' => 'progressions#destroy_progression_item',
    as: 'destroy_progression_item'

  ###################
  ## User Sessions ##
  ###################
  resources :passwords,
    controller: "clearance/passwords", only: [:create, :new]
  resource :session,
    controller: "clearance/sessions", only: [:new, :create]
  get 'session' => redirect('sign_in')

  resources :users, only: [:new, :create] do
    resource :password,
      controller: "clearance/passwords", only: [:edit, :update]
  end
  get 'sign_up' => "users#new", as: "sign_up"
  get 'account' => 'users#account'

  get "sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "sign_out" => "clearance/sessions#destroy", as: "sign_out"
end
