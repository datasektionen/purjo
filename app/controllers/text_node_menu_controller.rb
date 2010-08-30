class TextNodeMenuController < ApplicationController
  require_role 'editor'
  
  def edit
    @node = TextNode.find(params[:text_node_id])
    render :text=>params[:text_node_id]
  end

  def update
    @node = TextNode.find(params[:text_node_id])
  end

  def index
    #att bara lista menyn är värdelöst
    redirect_to :action => 'edit' 
  end
end
