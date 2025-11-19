Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  root to: "pages#home"

  # Pages routes
  resource :family, only: [:show, :new, :create, :edit, :update]

  # Calendar routes
  resource :families_calendar, only: [:show] do
    get 'new_event', on: :member
    post 'create_event', on: :member
    get 'new_unavailability', on: :member
    post 'create_unavailability', on: :member
    get 'edit_event', on: :member
    patch 'update_event', on: :member
    delete 'destroy_event', on: :member
    get 'edit_unavailability', on: :member
    patch 'update_unavailability', on: :member
    delete 'destroy_unavailability', on: :member
  end

  # Documents routes
  resource :families_documents, only: [:show]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
