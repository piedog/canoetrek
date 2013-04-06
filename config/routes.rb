Olapp::Application.routes.draw do

  get "users/new"

    resources :pois
    resources :users

    match '/map',       to: 'static_pages#map'
    match '/signup',    to: 'users#new'

    get "static_pages/home"

    get "proxy" => "proxy#get", :as =>"proxy"

    root to: 'pois#index'
end
