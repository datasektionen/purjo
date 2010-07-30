class SearchController < ApplicationController
  def index
    @search = Sunspot.search(TextNode, Post, Student) do
      keywords params[:q]
    end
  end
end