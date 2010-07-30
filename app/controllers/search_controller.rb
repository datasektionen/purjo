class SearchController < ApplicationController
  
  SEARCH_ENABLED_MODELS = [TextNode, Post, Student, Committee]
  def index
    @menu_template = "search"
    
    classes = SEARCH_ENABLED_MODELS

    @search = Sunspot.search(*classes) do
      keywords params[:q]
      facet :class
      
      paginate :page => params[:page]
      
      if params[:f]
        with(:class).equal_to(params[:f].classify.constantize)
      end
    end
  end
end