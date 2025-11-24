Rails.application.routes.draw do
  get 'family_events/index'
  resources :tasks do
    member do
      patch :toggle_status
    end
  end
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  root to: "pages#home"

  # Pages routes
  get 'families', to: 'families#show', as: :families  # Redirect /families to show action
  resources :families, only: [:show, :new, :create, :edit, :update] do
    resources :family_events
  end
  resources :people, only: [:new, :create, :edit, :update, :destroy]

  get 'families-documents', to: 'pages#families_documents', as: :families_documents

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  resources :events, only: [ :index, :create, :edit, :update, :destroy ]
  # root "posts#index"
end
