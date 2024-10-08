Rails.application.routes.draw do
  # resources :transactions
  # get "transactions_top_up" => "transactions#top_up", as: :top_up
  # post "transactions_top_up" => "transactions#create_top_up", as: :top_up_create
  resources :teams, :users do
    resources :transactions
    get "transactions_top_up" => "transactions#top_up", as: :top_up
    post "transactions_top_up" => "transactions#create_top_up", as: :top_up_create
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  get "login" => "sessions#index", as: :login
  post "login" => "sessions#create", as: :sign_in
  get "register" => "sessions#register", as: :register
  post "register" => "sessions#sign_up", as: :sign_up

  get "logout" => "sessions#destroy", as: :logout

  # api
  namespace :api do
    post "login" => "auth#login"
    post "transfer" => "transfer#create"
    post "check_balance" => "profile#check_balance"
    get "all_profile" => "profile#all_profile"
    post "price_all" => "rapid_api#price_all"
    post "price" => "rapid_api#price"
    post "prices" => "rapid_api#prices"
  end
  # Defines the root path route ("/")
  root :to => "transactions#index"
end
