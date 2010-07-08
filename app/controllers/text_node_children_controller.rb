class TextNodeChildrenController < ApplicationController
  require_role 'editor'
  
  def index
    @parent = TextNode.find(params[:text_node_id])
  end
  
  def new
    @parent = TextNode.find(params[:text_node_id])
    @node = @parent.children.new
  end
  
  def create 
    @parent = TextNode.find(params[:text_node_id])
    @child = @parent.children.build(params[:text_node])
    
    if @child.save
      flash[:notice] = "Nod \"#{@child.url}\" sparad!"
      redirect_to @child.url
    else
      flash[:error] = "Ett fel uppstod!"
      render :action => 'new'
    end
  end
end
