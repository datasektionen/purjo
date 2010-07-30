class SearchController < ApplicationController
  
  SEARCH_ENABLED_MODELS = [TextNode, Post, Student, Committee]
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
  end
end