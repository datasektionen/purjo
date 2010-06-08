class FileNodeChildrenController < ApplicationController
  def index
    @parent = TextNode.find(params[:node_id])
    @files = @parent.file_nodes
  end
  def new
    @parent = TextNode.find(params[:node_id])
    @node = @parent.file_nodes.build
  end
  
  def create
    @parent = TextNode.find(params[:node_id])
    @node = @parent.file_nodes.build(params[:file_node])
    
    if @node.save
      flash[:notice] = "Fil uppladdad"
      redirect_to @parent.url
    else
      flash[:error] = "Ett fel uppstod vid uppladdning av fil"
      render :action => 'edit'
    end
  end
end
