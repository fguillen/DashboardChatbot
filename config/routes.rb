require "sidekiq/web"
require "sidekiq/cron/web"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq", :constraints => AdminConstraint.new

  # root to: "guest/pages#show", id: "welcome"
  root to: redirect("front/conversations")

  namespace :admin do
    root to: redirect("admin/admin_users")

    get "login", to: "admin_sessions#new", as: :login
    delete "logout", to: "admin_sessions#destroy", as: :logout
    get "forgot_password", to: "admin_sessions#forgot_password", as: :forgot_password
    post "forgot_password", to: "admin_sessions#forgot_password_submit", as: :forgot_password_submit
    get "reset_password/:reset_password_code", to: "admin_users#reset_password", as: :reset_password
    patch "reset_password/:reset_password_code", to: "admin_users#reset_password_submit", as: :reset_password_submit

    resources :admin_sessions, only: [:new, :create, :destroy]
    resources :admin_users

    resources :log_book_events, only: [:index]
    resources :front_users do
      get "articles", on: :member
      get "conversations", on: :member
      get "user_reactions", on: :member
      get "log_book_events", on: :member
    end
    resources :articles

    resources :clients do
      get "front_users", on: :member
      get "log_book_events", on: :member
    end

    resources :articles_filters, only: [:new, :show] do
      get "create", on: :collection
    end

    resources :conversations
    resources :user_reactions, only: [:index]

    resources :impersonations, only: [:create]
  end

  namespace :api do
    namespace :admin do
      resources :admin_users, only: [:index, :show, :create, :update, :destroy], param: :uuid
    end

    namespace :front do
      resources :conversations, only: [:show, :new, :create, :index] do
        resources :messages, only: [:create]
      end
    end
  end

  namespace :front do
    root to: redirect("front/conversations")

    get "login", to: "front_sessions#new", as: :login
    get "logout", to: "front_sessions#destroy", as: :logout
    get "forgot_password", to: "front_sessions#forgot_password", as: :forgot_password
    post "forgot_password", to: "front_sessions#forgot_password_submit", as: :forgot_password_submit
    get "reset_password/:reset_password_code", to: "front_users#reset_password", as: :reset_password
    patch "reset_password/:reset_password_code", to: "front_users#reset_password_submit", as: :reset_password_submit
    get "my_profile", to: "front_users#my_profile"

    resources :front_sessions, only: [:new, :create, :destroy]

    resources :conversations, only: [:show, :new, :create, :index, :edit, :update] do
      resources :messages, only: [:create]
    end

    resources :alerts, only: [:index, :show, :edit, :update, :destroy] do
      get :process_alert, on: :member
    end
    resources :messages, only: [:show] do
      resources :user_reactions, only: [:create, :destroy]
    end
    resources :user_reactions, only: [:index] do
      delete :destroy_from_index, on: :member
    end
    resources :user_favorites, only: [:index, :destroy]

    resources :front_users, only: [:edit, :update] # , :new, :create, :destroy
  end

  namespace :guest do
    root to: redirect("guest/articles")
    resources :pages, only: [:show]
    resources :articles, only: [:show, :index]
  end

  get '/auth/:provider/callback' => 'admin/admin_authorizations#create', constraints: ->(request) { request.env['omniauth.params']['from'] == 'admin' }
  get '/auth/:provider/callback' => 'front/front_authorizations#create', constraints: ->(request) { request.env['omniauth.params']['from'] == 'front' }
  get '/auth/failure' => 'share/authorizations#failure'
  get '/auth/:provider' => 'share/authorizations#blank'

  get 'health', to: "application#health"
end
