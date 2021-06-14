# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :authorized_applications, :applications
  end

  namespace :admin do
    root to: 'dashboards#show'
    resources :applications
    resources :users, except: [:new, :create]
  end

  namespace :api do
    get 'swagger', to: 'documentation#show'
    resources :invitations, only: :create
    namespace :otp do
      resources :challenges, only: :create
    end
    resources :users, only: [] do
      scope module: :users do
        resources :trades, only: [:create, :index] do
          post '/:event', action: :event, constraints: { event: Trade.available_events.map(&:to_s) }, on: :member
        end
      end
    end
  end

  root to: 'users#show'

  resource :user, path: 'me', only: [:show]

  get 'sessions/destroy', to: 'sessions#destroy'
  
  resource :sessions, path: 'login', only: [:new, :create, :destroy, :show]
  namespace :sessions, path: '' do
    resources :backups, path: 'backup-codes', only: [:show, :update]
    namespace :otp do
      resource :challenges, only: [:new, :create]
      resource :responses, only: [:new, :create], path: 'responses/:id'
    end
    namespace :token do
      resource :requests, only: :create, path: 'requests/:id'
      get 'response/:token', to: 'responses#create', as: :response
    end
  end

  scope '.well-known', module: :well_known, as: :well_known, defaults: { format: 'json' } do
    resources :keys, path: 'jwks', only: :index
    resource :discovery, path: 'openid-configuration', only: :show
    resource :users, path: 'user-info', only: :show
    resource :webfinger, only: :show
  end
  
  resources :invitations, only: [:show, :update]
  resource :registrations, only: [:new, :create]

  match '/unauthenticated', to: 'exceptions#unauthenticated', via: [:get, :post]
  match '/404',             to: 'exceptions#show', via: [:get, :post]
  match '/500',             to: 'exceptions#show', via: [:get, :post]
end
