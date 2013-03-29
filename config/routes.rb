Olapp::Application.routes.draw do

    resources :pois

    match '/map',       to: 'static_pages#map'

    get "static_pages/home"

    get "proxy" => "proxy#get", :as =>"proxy"

    root to: 'pois#index'
end
