class NodesController < ApplicationController
  def show
    url = "/" + params[:url].join("/")
    @node = Node.find_by_url(url)
    
    raise ActiveRecord::RecordNotFound if @node.nil?
    
    if @node.is_a? TextNode
      if params[:url][0] == "sektionen"
        @menu_template = "sektionen"
      elsif params[:url][0] == "naringsliv"
        @menu_template = "naringsliv"
      elsif params[:url][0] == "studier"
        @menu_template = "studier"
      elsif params[:url][0] == "kontakt"
        @menu_template = "kontakt"
      end

      begin
        render "text_nodes/show", :layout => @node.layout
      rescue Liquid::SyntaxError => @exception
        render :template => 'text_nodes/syntax_error'
      end
    elsif @node.is_a? FileNode
      send_data(File.read(@node.resource.path), :disposition => "inline", :type => @node.resource.content_type)
    end
  end
end
