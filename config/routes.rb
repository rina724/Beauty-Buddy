Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords",
    confirmations: "users/confirmations",
    omniauth_callbacks: "users/omniauth_callbacks"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
  root "static_pages#top"
  get "contact", to: "static_pages#contact"
  get "privacy", to: "static_pages#privacy"
  get "terms_of_service", to: "static_pages#terms_of_service"
  post "callback" => "line_bot#callback"

  resources :users, only: %i[show]
  resources :cosmetics, only: %i[index show] do
    collection do
      get :favorites
      get :search
    end
    resource :favorite, only: %i[create destroy]
  end

  resources :mycosmetics, only: %i[new create index edit update destroy] do
    collection do
      get :search
    end
  end
  resources :profiles, only: %i[index update] do
    member do
      patch :update_allergy
    end
  end
  resources :daily_reports, only: %i[new create index show edit update destroy]
end
