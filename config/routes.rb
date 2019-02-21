Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :locations
    resources :longhurst_provinces
    resources :measurements
    resources :measurement_methods
    resources :measurement_models
    resources :observations
    resources :precision_types
    resources :resources
    resources :sex_types
    resources :species
    resources :species_superorders
    resources :standards
    resources :traits
    resources :trait_classes
    resources :value_types

    root to: "users#index"

    authenticate :user, lambda { |u| u.admin? } do
      require 'sidekiq/web'
      mount Sidekiq::Web => '/sidekiq'
    end
  end

  devise_for :users

  resources :imports do
    post :approve, to: 'imports#approve'
    post :request_changes, to: 'imports#request_changes'
    post :reject, to: 'imports#reject'
  end

  root 'pages#start'

  get 'home/index'

  # static pages
  match '/about',   to: 'pages#about',   via: 'get'
end
