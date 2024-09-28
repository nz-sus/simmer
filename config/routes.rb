Rails.application.routes.draw do
  get 'masked_secrets/show'
  resources :gitleaks_results do
    member do
      patch :add_tag
      patch :remove_tag      
    end
    collection do
      post :update_filters
      get :update_filters_g
      get :assign_severities
    end
  end
  resources :incidents
  resources :log_entries
  resources :data_sets do
    collection do
      get :bulk_import
    end
    member do
      post :import_form
      post :import_json
    end
  end
  resources :service_tokens do
    collection do
      post :create_service_token
    end
  end
  resources :clients do 
    collection do
      post :set_active
      post :set_minimum_display_severity
    end
    member do
      get 'export'
      get 'report'
    end
    #Access Masked Secrets for a client
    resources :masked_secrets, only: [:index, :show, :update] do
      collection do
        get 'export'
      end
    end
  end

  devise_for :user, controllers: {
    sessions: 'user/sessions'
  }
  get '/notes/:type/:id', to: 'notes#show'
  post '/notes/:type/:id', to: 'notes#create'

  # API for the frontend to make AJAX requests
  # config/routes.rb
  namespace :api do
    namespace :internal do
      resources :clients, only: [:create, :update, :destroy, :show, :index]
      resources :data_sets, only: [:create, :update, :destroy, :show, :index]      
    end
    namespace :v1 do
      resources :clients, only: [:create, :update, :destroy, :show, :index]
      resources :data_sets, only: [:create, :update, :destroy, :show, :index]      
    end
  end



  # Allow users to sign out with a get request to /users/sign_out
  # devise_scope :user do
  #   get "/users/sign_out" => "devise/sessions#destroy"
  # end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "data_sets#index"
end
