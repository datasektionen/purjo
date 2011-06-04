Rails.application.routes.draw do
  
  resources :blogs do
    resources :articles
  end

  match "travel_years/:year/internt/*url", :to => 'studs_nodes#show'
  
  resources :travel_years do
    resources :cvs
    collection do
      get :logout
      get :login
      post :login
    end
  end
  
  # URL-mappning
  root :to => 'travel_years#index'
end
