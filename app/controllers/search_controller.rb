class SearchController < ApplicationController
  
  SEARCH_ENABLED_MODELS = [TextNode, Post, Event, Person, Committee]
  def index
    @menu_template = "search"
    
    classes = SEARCH_ENABLED_MODELS

    @search = Sunspot.search(*classes) do
      keywords params[:q]
      facet :class
      facet :tags
      
      paginate :page => params[:page]
      
      if params[:ft]
        with(:class).equal_to(params[:ft].constantize)
      end
      if params[:f]
        with(:tags).equal_to(params[:f])
      end
      
    end
    
    @hit_count = @search.total
    
    @hits_and_results = []
    hidden_users = Morklaggning.all.map(&:person)
    @search.each_hit_with_result do |hit, result|
      if hidden_users.include?(result)
        @hit_count -= 1
        next
      end
      @hits_and_results << [hit, result]
    end
    
    
  end
end
