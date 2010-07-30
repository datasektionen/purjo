class SearchController < ApplicationController
  def index
    @search = Sunspot.search(TextNode, Post, Student, Committee) do
      keywords params[:q]
    end
  end
end