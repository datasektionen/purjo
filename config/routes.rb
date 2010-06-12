Rails.application.routes.draw do |map|
  map.protocols '/protocols', :controller => 'protocols', :action => 'index'
  
  map.protocol "/protocols/:filename", :controller => 'protocols', :action => 'show'
  map.protocol "/protocols/:filename.:format", :controller => 'protocols', :action => 'show'

  map.resources :noises

  map.resources :morklaggnings, :as => 'morklaggning'


#  # Måste ligga ovanför alla resurser som använder auto_complete:
#  map.auto_complete ':controller/:action',
#    :requirements => { :action => /auto_complete_for_\S+/ },
#    :conditions => { :method => :get }
#
#  map.resources :nominees, :as => "sektionen/val"
#
#  map.resources :election_events
#
#  map.resources :chapter_posts
#
#  map.resources :functionaries, :as => "sektionen/funktionarer"

  map.resources :blogs do |blogs|
    blogs.resources :articles
  end

  map.resources :students

  map.resource :front_page

  map.resources :cvs, :path_prefix => 'sektionen/studs/:year', :collection => {:logout => :get, :login => :any}
  map.connect "sektionen/studs/:year/internt/*url", :controller => 'studs_nodes', :action => 'show'
  
  map.resources :travel_years

  map.resources :changes

  map.resources :job_ads, :except => [:show]

  map.resources :feedbacks

  map.resources :list_fields

  map.resources :lists do |lists|
    lists.resources :list_entries, :shallow => true
  end

  map.resource :sessions

  map.resources :kth_accounts

  map.resources :people do |people|
    people.resource :settings, :controller => 'my_settings'
  end

  map.resources :students, :member => {:xfinger => :get}, :as => 'sektionen/sok'

  map.resources :menu_tests

  map.resources :text_nodes do |text_nodes|
    text_nodes.resources :children, :controller => 'TextNodeChildren', :path_prefix => 'text_nodes/:node_id'
    text_nodes.resources :files, :controller => 'FileNodeChildren', :path_prefix => 'text_nodes/:node_id'
    text_nodes.resources :versions, :controller => 'TextNodeVersions', :member => {:revert => :put}
  end

  map.resources :file_nodes

  map.resources :posts, :as => 'nyheter'

  map.calendar '/kalender/:year/:month', :controller => 'calendars', :action => 'show', :month => nil, :year => nil
  map.calendar_ics '/kalender.ics', :controller => 'calendars', :action => 'show', :format => 'ics'

  map.lunch '/lunch/:date', :controller => 'lunch', :action => 'index', :date => nil

  map.naringsliv_index '/sektionen/namnder/naringsliv', :controller => 'job_ads', :action => 'naringsliv_index'

  map.schema '/schema/proxy.:format', :controller => 'schema', :action => 'proxy'
  map.schema '/schema/:year', :controller => 'schema', :action => 'index', :year => 'D1'

  map.root :controller => 'front_pages', :action => 'show'

  map.connect "*url", :controller => 'nodes', :action => 'show'
end

