Rails.application.routes.draw do |map|
  
  match "/admin", :to => 'admin#index'
  
  resources :blogs do
    resources :articles
  end
  
  resources :namnder, :as => 'committees', :controller => 'committees'
    
  get "/kontakt/:slug" => 'contact#index', :as => 'contact'
  post "/kontakt/:slug" => 'contact#send_mail'
  
  resources 'kth-konton', :as => 'kth_accounts', :controller => 'kth_accounts'
  
  resources :morklaggning, :as => 'morklaggnings', :controller => 'morklaggnings'
  
  resources 'sektionen/funktionarer', :as => "functionaries", :controller => 'functionaries'
  resources 'sektionen/nyhetsbrev', :as => 'newsletters', :controller => 'newsletters' do
    resources :sektion, :as => 'newsletter_sections', :controller => 'newsletter_sections'
    resource :test_delivery
    resource :live_delivery
    get :admin, :on => :collection
  end
  match "/newsletters/hook/:secret", :to => 'newsletter_hooks#mailchimp_endpoint', :via => [:post, :get]
  match "/nyhetsbrev" => redirect("/sektionen/nyhetsbrev")
  
  resources :personer, :as => 'people', :controller => 'people' do
    resource :installningar, :controller => 'user_settings', :as => 'user_settings'
    member do
      get :xfinger
    end
  end

  get '/installningar', :to => 'user_settings#edit_current', :as => 'settings'

  map.xfinger_image 'people/xfinger_image/:uid', :controller=>'people',:action=>'xfinger_image'
  
  resources :nyheter, :as => 'posts', :controller => 'posts' do
    resources :kommentarer, :as => 'noises', :controller => 'noises'
  end
  resources :kommentarer, :as => 'noises', :controller => 'noises'
  
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
  
  resources :file_nodes
  
  resources 'textnoder', :as => :text_nodes, :controller => 'text_nodes' do
    resources :children, :controller => 'TextNodeChildren', :path_prefix => 'textnoder/:node_id'
    resources :filer, :as => :files, :controller => 'FileNodeChildren', :path_prefix => 'textnoder/:node_id'
    resources :versioner, :as => :versions, :controller => 'TextNodeVersions' do
      member do
        put :revert
      end
    end
    
    member do
      get :delete
    end
  end

  match '/textnoder/:text_node_id/meny', :controller => 'TextNodeMenu', :action => 'update', :via => :put
  match '/textnoder/:text_node_id/meny', :controller => 'TextNodeMenu', :action => 'add',:via=>:post
  match '/textnoder/:text_node_id/meny/delete/:id', :controller => 'TextNodeMenu', :action => 'delete', :via => :delete

  map.delete_text_node_menu '/textnoder/:text_node_id/meny/delete/:id'
  map.edit_text_node_menu '/textnoder/:text_node_id/meny', :controller => 'TextNodeMenu', :action => 'edit'
  
  match "/protokoll/:filename", :to => "protocols#show", :as => 'protocol'
  match "/protokoll", :to => "protocols#index", :as => 'protocols'
  
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

  resources '/sektionen/valtillfallen', :as => 'election_events', :controller => 'election_events'
  resources '/sektionen/val', :as => 'nominees', :controller => 'nominees'

  resources 'sektionen/funktionarsposter', :as => 'chapter_posts', :controller => 'chapter_posts'
  resources 'sektionen/funktionarer', :as => 'functionaries', :controller => 'functionaries' 

  resources :taggar, :as => 'tags', :controller => 'tags', :only => [:index, :destroy] do
    post :update_multiple
  end

  root :to => 'front_pages#show'

  match "*url", :controller => 'nodes', :action => 'show',
    :constraints => { :url => /^\/(?!stylesheets|javascripts)/ }

end
