class TextNodeMenuController < ApplicationController
  require_role 'editor'
  
  def edit
    @node = TextNode.find(params[:text_node_id])
  end

  def update
    @node = TextNode.find(params[:text_node_id])
  end

  def add
    @node = TextNode.find(params[:text_node_id])
    @node_to_add = TextNode.find(params[:id])

    if @node.add_node_to_menu(@node_to_add,@node_to_add.name)
      flash[:notice] = "La till #{@node_to_add.name} i menyn"
    else
      flash[:error] = "Kunde inte lägga till #{@node_to_add.name} i menyn"
    end
    render :action=>'edit'
  end

end
