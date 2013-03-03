Olapp::Application.routes.draw do

    resources :pois

    match '/map',       to: 'static_pages#map'

    get "static_pages/home"

    root to: 'pois#index'
end
