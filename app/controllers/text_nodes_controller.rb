class TextNodesController < ApplicationController
  require_role 'editor'
  require_role 'admin', :only => [:destroy, :delete]
  def edit
    @node = TextNode.find(params[:id])
    
  end
  
  def update
    @node = TextNode.find(params[:id])
    
    if @node.update_attributes(params[:text_node])
      flash[:notice] = "Nod \"#{@node.url}\" sparad"
      redirect_to @node.url
    else
      flash[:error] = "Ett fel uppstod när noden sparades."
      render :action => 'edit'
    end
  end
  
  def destroy
    @node = TextNode.find(params[:id])
    parent = @node.parent
    
    @node.destroy
    redirect_to(parent.url)
  end
  
  def delete
    @node = TextNode.find(params[:id])
  end
end
