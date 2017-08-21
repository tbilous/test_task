Rails.application.routes.draw do

  resources :teams do
    resources :collaborators, shallow: true, only: %i(new create update destroy)
    resources :tasks, shallow: true, only: %i(new edit create update destroy)
    get 'collaborators/staff'
  end

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
