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
    end
  devise_for :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'pages#start'

  get 'home/index'

  # static pages
  match '/about',   to: 'pages#about',   via: 'get'
end
