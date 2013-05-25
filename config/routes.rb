Olapp::Application.routes.draw do

  # get "users/new"

    resources :users do
        member do
            get :following, :followers
        end
    end
  # resources :pois
    resources :sessions,   only: [:new, :create, :destroy]
    resources :microposts, only: [:create, :destroy]
    resources :relationships, only: [:create, :destroy]

  # root to: 'pois#index'
    root to: 'static_pages#home'
  # root to: 'static_pages#map'

    match '/signup',    to: 'users#new'
    match '/signin',    to: 'sessions#new'
    match '/signout',   to: 'sessions#destroy', via: :delete


    match '/map',       to: 'static_pages#map'

    match '/help',      to: 'static_pages#help'

  # get "static_pages/home"

    get "proxy" => "proxy#get", :as =>"proxy"




end
