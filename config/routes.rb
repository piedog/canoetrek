Olapp::Application.routes.draw do

  # get "users/new"

    resources :users do
        member do
            get :following, :followers
        end
        resources :trips, only: [:index, :create, :destroy]  ## if we remove this, the home page does not work
        resources :enrollments, only: [:index, :create, :destroy]
    end

    resources :trips do
        resources :participants, only: [:index, :create, :destroy]
    end

    resources :trips, only: [:create, :destroy]    ## if i remove this, the create trip does not work

    resources :sessions,   only: [:new, :create, :destroy]
    resources :microposts, only: [:create, :destroy]
    resources :relationships, only: [:create, :destroy]

    root to: 'static_pages#home'

    match '/signup',    to: 'users#new'
    match '/signin',    to: 'sessions#new'
    match '/signout',   to: 'sessions#destroy', via: :delete


    match '/map',       to: 'map#map'

    match '/help',      to: 'static_pages#help'
    match '/about',     to: 'static_pages#about'
    match '/contact',   to: 'static_pages#contact'

    match '/trips',      to: 'trips#alltrips'



    get "proxy" => "proxy#get", :as =>"proxy"




end
