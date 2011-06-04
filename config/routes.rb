Rails.application.routes.draw do |map|
  
  match "/admin", :to => 'admin#index'
  
  resources :blogs do
    resources :articles
  end
  
  # Studs-relaterat
  map.resources :travel_years
  map.resources :cvs, :path_prefix => 'sektionen/studs/:year', :collection => {:logout => :get, :login => :any}
  map.connect "sektionen/studs/:year/internt/*url", :controller => 'studs_nodes', :action => 'show'

  # URL-mappning

  root :to => 'front_pages#show'

  match "*url" => 'nodes#show'
end
