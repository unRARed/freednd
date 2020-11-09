Rails.application.routes.draw do
  mount ActionCable.server => '/cable'

  root 'landing_pages#index'
  get 'license' => 'landing_pages#license'
  get 'faq' => 'landing_pages#faq'

  resources :characters
  get 'characters/:id/rp/:field' => 'characters#edit_content_field',
    as: 'edit_character_content_field'

  resources :campaigns do
    resources :npcs
  end
  post 'campaigns/:id/join' => 'campaigns#join',
    as: 'join_campaign'
  post 'campaigns/:id/add_game_master' => 'campaigns#add_game_master',
    as: 'add_game_master'
  delete 'campaigns/:campaign_id/' +
    'progressions/:progression_id/' +
    'progression_items/:id' => 'progressions#destroy_progression_item',
    as: 'destroy_progression_item'


  resources :progressions, only: [:update]
  get 'campaigns/:campaign_id/progressions/:id/show_for_print' =>
    'progressions#show_for_print',
    as: 'print_campaign_progression'
  get 'campaigns/:campaign_id/progressions/:id/inventory' =>
    'progressions#edit_inventory',
    as: 'edit_campaign_progression_inventory'
  get 'campaigns/:campaign_id/progressions/:id/wallet' =>
    'progressions#edit_wallet',
    as: 'edit_campaign_progression_wallet'
  get 'campaigns/:campaign_id/progressions/:id/abilities' =>
    'progressions#edit_abilities',
    as: 'edit_campaign_progression_abilities'
  get 'campaigns/:campaign_id/progressions/:id/status' =>
    'progressions#edit_status',
    as: 'edit_campaign_progression_status'
  get 'campaigns/:campaign_id/progressions/:id/skills' =>
    'progressions#edit_skills',
    as: 'edit_campaign_progression_skills'
  get 'campaigns/:campaign_id/progressions/:id/spells' =>
    'progressions#edit_spells',
    as: 'edit_campaign_progression_spells'
  get 'campaigns/:campaign_id/progressions/:id/features' =>
    'progressions#edit_features',
    as: 'edit_campaign_progression_features'
  get 'campaigns/:campaign_id/progressions/:id/equipment' =>
    'progressions#edit_equipment',
    as: 'edit_campaign_progression_equipment'
  post 'campaigns/:campaign_id/progressions/:id/wallet' =>
    'progressions#update_wallet',
    as: 'update_campaign_progression_wallet'
  post 'campaigns/:campaign_id/progressions/:id/roll_dice' =>
    'progressions#roll_dice',
    as: 'campaign_progression_dice_roll'

  ###################
  ## User Sessions ##
  ###################

  # New user passwords
  resources :passwords,
    controller: "passwords", only: [:create, :new]
  resource :session,
    controller: "clearance/sessions", only: [:new, :create]
  get 'session' => redirect('sign_in')

  resources :users, only: [:new, :create] do
    # Password changes
    resource :password,
      controller: "passwords", only: [:create, :edit, :update]
  end
  get 'sign_up' => "users#new", as: "sign_up"
  get 'account' => 'users#account'

  get "sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "sign_out" => "clearance/sessions#destroy", as: "sign_out"
end
