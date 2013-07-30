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
  end

  get '/installningar', :to => 'user_settings#edit_current', :as => 'settings'

  match '/nyheter/utkast/', :to => 'front_pages#show', :as => 'drafts', :drafts => true
  resources :nyheter, :as => 'posts', :controller => 'posts' do
    resources :kommentarer, :as => 'noises', :controller => 'noises'
  end
  resources :kommentarer, :as => 'noises', :controller => 'noises'
  
  match "/sok", :to => 'search#index', :as => 'search'
  
  resource :session, :as => 'sessions', :controller => 'sessions'
  match "/session/logga-ut", :to => 'sessions#destroy', :as => 'logout'

  resources 'sektionen/funktionarer', :as => "functionaries", :controller => 'functionaries'
  resources 'sektionen/val', :as => "nominees", :controller => 'nominees'
  match '/sektionen/naringsliv', :controller => 'naringsliv', :action => 'index', :as => 'naringsliv_index'
  resources '/sektionen/naringsliv/jobb', :controller => 'job_ads', :as => 'job_ads', :except => [:show]
  
  resources 'filnoder', :as => :file_nodes, :controller => 'file_nodes'
  
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

  # URL-mappning

  get '/kalender(/:year/:month)' => 'calendars#show', :as => :calendar,
    :month => nil, :year => nil,
    :constraints => { :month => /\d+/, :year => /\d+/ }
  get '/kalender.ics' => 'calendars#show', :as => :calendar_ics, :format => 'ics'
  resources '/kalender', :as => 'events', :controller => 'events', :except => :index

  resources '/sektionen/valtillfallen', :as => 'election_events', :controller => 'election_events'
  resources '/sektionen/val', :as => 'nominees', :controller => 'nominees'

  resources 'sektionen/funktionarsposter', :as => 'chapter_posts', :controller => 'chapter_posts'
  resources 'sektionen/funktionarer', :as => 'functionaries', :controller => 'functionaries' 

  resources :taggar, :as => 'tags', :controller => 'tags', :only => [:index, :destroy] do
    post :update_multiple
  end

  root :to => 'front_pages#show'
  match '/rss', :to => 'front_pages#rss'

  match "*url" => 'nodes#show'
end
