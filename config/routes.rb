Rails.application.routes.draw do
  resources :teams
  resources :users
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
  # Defines the root path route ("/")
  root "users#index"
end
