class FileNodeChildrenController < ApplicationController
  def index
    @parent = TextNode.find(params[:text_node_id])
    @files = @parent.file_nodes
  end
  def new
    @parent = TextNode.find(params[:text_node_id])
    @node = @parent.file_nodes.build
  end
  
  def create
    @parent = TextNode.find(params[:text_node_id])
    params[:file_node][:resource].each do |file_node|
      @node = @parent.file_nodes.build({:resource => file_node})
      unless @node.save
        flash[:error] = "Ett fel uppstod vid uppladdning av fil"
        render :action => 'new'
	return
      end
    end

    flash[:notice] = "Fil uppladdad"
    redirect_to @parent.url
  end
end
