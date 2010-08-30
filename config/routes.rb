Rails.application.routes.draw do |map|
  
  match "/admin", :to => 'admin#index'
  
  resources :blogs do
    resources :articles
  end
  
  resources :committees
  
  resources :file_nodes
    
  get "/kontakt/:slug" => 'contact#index', :as => 'contact'
  post "/kontakt/:slug" => 'contact#send_mail'
  
  resources :kth_accounts
  
  resources :morklaggnings, :as => 'morklaggning'
  
  resources :newsletters do
    resources :newsletter_sections
    resource :test_delivery
    resource :live_delivery
  end
  match "/newsletters/hook/:secret", :to => 'newsletter_hooks#mailchimp_endpoint', :via => [:post, :get]
  
  
  
  resources :people do
    resource :settings, :controller => 'user_settings', :as => 'user_settings'
    member do
      get :xfinger
    end
  end

  map.xfinger_image 'people/xfinger_image/:uid', :controller=>'people',:action=>'xfinger_image'
  
  resources 'nyheter', :as => 'posts', :controller => 'posts' do
    resources :noises
  end
  resources :noises
  
  
  match "/sok", :to => 'search#index', :as => 'search'
  
  resource :sessions
  resources 'sektionen/sok', :as => 'students', :controller => 'students' do
    member do
      get :xfinger
    end
  end
  
  resources 'sektionen/funktionarer', :as => "functionaries", :controller => 'functionaries'
  resources 'sektionen/val', :as => "nominees", :controller => 'nominees'
  match '/sektionen/naringsliv', :controller => 'naringsliv', :action => 'index', :as => 'naringsliv_index'
  resources '/sektionen/naringsliv/jobb', :controller => 'job_ads', :as => 'job_ads', :except => [:show]
  
  
  resources :text_nodes do
    resources :children, :controller => 'TextNodeChildren', :path_prefix => 'text_nodes/:node_id'
    resources :files, :controller => 'FileNodeChildren', :path_prefix => 'text_nodes/:node_id'
    resources :versions, :controller => 'TextNodeVersions' do
      member do
        put :revert
      end
    end
    
    member do
      get :delete
    end
  end

  match '/text_nodes/:text_node_id/menu', :controller => 'TextNodeMenu', :action => 'update', :via => :put
  match '/text_nodes/:text_node_id/menu', :controller => 'TextNodeMenu', :action => 'add', :via => :post
  match '/text_nodes/:text_node_id/menu', :controller => 'TextNodeMenu', :action => 'delete', :via => :delete

  map.edit_text_node_menu '/text_nodes/:text_node_id/menu', :controller => 'TextNodeMenu', :action => 'edit'
  
  match "/protocols/:filename", :to => "protocols#show", :as => 'protocol'
  match "/protocols", :to => "protocols#index", :as => 'protocols'
  
  root :to => 'front_pages#show'
  match '/rss', :to => 'front_pages#rss'

  # Studs-relaterat
  map.resources :travel_years
  map.resources :cvs, :path_prefix => 'sektionen/studs/:year', :collection => {:logout => :get, :login => :any}
  map.connect "sektionen/studs/:year/internt/*url", :controller => 'studs_nodes', :action => 'show'

  # URL-mappning

  map.calendar '/kalender/:year/:month', :controller => 'calendars', :action => 'show', :month => nil, :year => nil
  map.calendar_ics '/kalender.ics', :controller => 'calendars', :action => 'show', :format => 'ics'

  map.lunch '/lunch/:date', :controller => 'lunch', :action => 'index', :date => nil


  map.schema '/schema/proxy.:format', :controller => 'schema', :action => 'proxy'
  map.schema '/schema/:year', :controller => 'schema', :action => 'index', :year => 'D1'

  resources '/sektionen/val', :as => 'nominees', :controller => 'nominees'

  map.resources :election_events

  map.resources :chapter_posts, :as => "sektionen/funktionarsposter"
  map.resources :functionaries, :as => "sektionen/funktionarer"

  map.root :controller => 'front_pages', :action => 'show'

  map.connect "*url", :controller => 'nodes', :action => 'show'

end
