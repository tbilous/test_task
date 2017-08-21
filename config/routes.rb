Rails.application.routes.draw do

  # patch 'tasks/set_state', as: 'state'
  resources :teams do
    resources :collaborators, shallow: true, only: %i(new create update destroy)
    resources :tasks, shallow: true do
      put '/:state', to: 'tasks#set_state', as: :state
    end
    get 'collaborators/staff'
  end
  # /my-:param(-can-be-:optional)(-and-this-:too)
  get 'collaborators/staff'
  get 'home/index'

  devise_for :users

  devise_scope :user do
    authenticated :user do
      root 'home#index', as: :authenticated_root
    end

    unauthenticated do
      root 'devise/sessions#new', as: :unauthenticated_root
    end
  end
end
