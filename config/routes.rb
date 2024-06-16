Rails.application.routes.draw do
  resources :store_items
  devise_for :users
  
  resources :stores do
    member do
      patch :deactivate
    end
    resources :products, only: [:index]
  end

  namespace :admin do
    resources :sellers
  end
    
  
  get "listing" => "products#listing"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  post "new" => "registrations#create", as: :create_registration
  get "me" => "registrations#me"
  post "sign_in" => "registrations#sign_in"

  scope :buyers do
    resources :orders, only: [:index, :create, :update, :destroy]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  root to: "welcome#index"
  get "up" => "rails/health#show", as: :rails_health_check

  #rota para login no vue_consumy
  get '/sign_in', to: 'sessions#new'

  # Defines the root path route ("/")
  # root "posts#index"
end
