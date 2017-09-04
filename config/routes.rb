Rails.application.routes.draw do

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      as :user do
        post '/registrations' => 'registrations#create'
        post '/sign-in' => 'sessions#create'
        delete '/sign-out' => 'sessions#destroy'
        resource :profiles do
          get :me
        end
      end
    end
  end

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
