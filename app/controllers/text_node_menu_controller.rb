class TextNodeMenuController < ApplicationController
  require_role 'editor'
  
  def edit
    @node = TextNode.find(params[:text_node_id])
  end

  def update
    @node = TextNode.find(params[:text_node_id])
    menu_items=params[:menu_item]
    menu_items.each do |id,m|
      item=MenuItem.find(id)
      item.title=m[:title]
      item.sort_order=m[:sort_order]
      item.save
    end
    flash[:notice] = "Ändringarna har sparats"
    render :action=>'edit'
  end

  def add
    @node = TextNode.find(params[:text_node_id])
    title = params[:title]
    url = params[:url]

    if @node.add_node_to_menu(title,url)
      flash[:notice] = "La till #{title} i menyn"
      @node=TextNode.find(params[:text_node_id]) #ladda om noden
    else
      flash[:error] = "Kunde inte lägga till #{title} i menyn"
    end
    render :action=>'edit'
  end

  def delete
    #if params[:ajax]!='true'
      @node = TextNode.find(params[:text_node_id])
      if MenuItem.delete(params[:id])
        flash[:notice] = "Posten togs bort ur menyn"
      else
        flash[:error] = "Kunde inte ta bort posten ur menyn"
      end
      redirect_to edit_text_node_menu_path(@node)
    #else
    #  if MenuItem.delete(params[:id])
    #    render :text=>'OK'
    #  else
    #    render :text=>'ERROR'
    #  end
    #end
  end

end
