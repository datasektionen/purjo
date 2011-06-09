Rails.application.routes.draw do

  match '/login' => 'cvs#login', :as => 'login'
  match '/logout' => 'cvs#logout', :as => 'logout'
  
  resources :blogs do
    resources :articles
  end

  match 'travel_years/:year/internt/*url' => 'studs_nodes#show'
  
  resources :travel_years do
    resources :cvs
  end
  
  # URL-mappning
  root :to => 'travel_years#index'
end
