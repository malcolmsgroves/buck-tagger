Rails.application.routes.draw do
  get 'notifications/index'

  get '/home', to: 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'

  devise_for :users, controllers: { omniauth_callbacks: "omniauth_callbacks",
                                    registrations: "registrations" }
  resources :users do
    member do
      get :following, :followers
    end
  end

  resources :relationships, only: [:create, :destroy]
  resources :posts,         only: [:create, :destroy, :show]
  resources :comments,      only: [:create, :destroy]
  resources :likes,         only: [:create, :destroy]
  resources :notifications, only: [:index]

  root 'static_pages#home'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
