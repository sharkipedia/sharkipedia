Rails.application.routes.draw do
  namespace :admin do
    resources :users
    resources :authors
    resources :locations
    resources :longhurst_provinces
    resources :measurements
    resources :measurement_methods
    resources :measurement_models
    resources :observations
    resources :precision_types
    resources :references
    resources :sex_types

    resources :analysis_models

    resources :species_subclasses
    resources :species_superorders
    resources :species_orders
    resources :species_families
    resources :species
    resources :species_groups
    resources :species_data_types

    resources :standards
    resources :traits
    resources :trait_classes
    resources :value_types

    resources :trends
    resources :trend_observations
    resources :oceans
    resources :sampling_methods
    resources :data_types
    resources :validation_types

    resources :imports

    root to: "users#index"

    authenticate :user, ->(user) { user.admin? } do
      mount GoodJob::Engine => "good_job"
    end
  end

  devise_for :users, controllers: {
    sessions: "users/sessions"
  }

  namespace :api do
    namespace :v1 do
      resources :boundaries, only: [:index, :show], param: :name
      resources :species, only: [:index, :show]
      post "species/query", to: "species#query"
    end
  end

  resources :imports do
    post :approve, to: "imports#approve"
    post :request_changes, to: "imports#request_changes"
    post :reject, to: "imports#reject"
    post :request_review, to: "imports#request_review"
  end

  root "pages#start"

  resources :locations, only: :create

  resources :trends
  resources :traits, only: [:index, :show]
  resources :observations

  resources :species, only: [:index, :show]
  resources :protected_species, only: [:index]
  resources :references, only: [:index, :show, :new, :create]

  namespace :search do
    get "autocomplete", defaults: {format: "json"}
  end

  resources :data_export, only: :index

  get "home/index"

  # static pages
  match "/about", to: "pages#about", via: "get"
  match "/contact", to: "pages#contact", via: "get"
  match "/api", to: "pages#api", via: "get"
  match "/procedure", to: "pages#procedure", via: "get"
end
