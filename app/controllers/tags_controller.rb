class TagsController < ApplicationController
  require_role :admin

  def index
    @tags = ActsAsTaggableOn::Tag.all
  end

  def update_multiple
    ActsAsTaggableOn::Tag.update(params[:tags].keys, params[:tags].values)
    flash[:notice] = "Taggarna har uppdaterats"
    redirect_to :action => 'index'
  end

  def destroy
    tag = ActsAsTaggableOn::Tag.find(params[:id])
    tag.destroy
    redirect_to tags_path
  end
end
