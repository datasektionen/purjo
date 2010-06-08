class TextNodeVersionsController < ApplicationController
  require_role 'editor'
  before_filter :load_node
  
  def index

    @versions = @node.versions
  end
  
  def show
    @version = @node.versions.find(params[:id])
    @oldver = @node.versions[@node.versions.size - 2]
    render :action => 'show'
  end
  
  def revert
    @version = @node.versions.find(params[:id])
    
    @node.revert_to(@version.version)
    @node.save!
    flash[:notice] = "#{@node.url} restored to version #{@version.version}"
    redirect_to text_node_versions_path(@node)
  end

  protected
  def load_node
    @node = TextNode.find(params[:text_node_id])
  end
end

