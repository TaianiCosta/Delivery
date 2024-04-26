Rails.application.routes.draw do
  devise_for :users
  resources :stores
  get "listing" => "products#listing"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  post "new" => "registrations#create", as: :create_registration
  get "me" => "registrations#me"
  post "sign_in" => "registrations#sign_in"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  root to: "welcome#index"
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end