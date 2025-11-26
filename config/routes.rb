Rails.application.routes.draw do
  get 'family_events/index'
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  root to: "pages#home"

  # Global search
  get 'search', to: 'searches#global', as: :global_search

  # Pages routes
  get 'families', to: 'families#show', as: :families  # Redirect /families to show action
  resources :families, only: [:show, :new, :create, :edit, :update] do
    resources :family_events
    resources :tasks do
      member do
        patch :toggle_status
      end
    end
  end
  resources :people, only: [:new, :create, :edit, :update, :destroy]

  get 'families-documents', to: 'pages#families_documents', as: :families_documents

  # Documents and Folders
  resources :folders, only: [:index, :show, :create, :update, :destroy]
  resources :documents, only: [:index, :show, :create, :update, :destroy] do
    member do
      patch :toggle_favorite
      get :download
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  resources :events, only: [ :index, :create, :update, :destroy ]

  # Chat routes
  resources :chats, only: [:index, :show, :create, :destroy] do
    resources :messages, only: [:create]
  end
  # root "posts#index"
end
