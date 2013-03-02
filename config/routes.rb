Olapp::Application.routes.draw do

    root to: 'pois#index'
    resources :pois
end
