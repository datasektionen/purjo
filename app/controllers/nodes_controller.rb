class NodesController < ApplicationController
  skip_before_filter :verify_authenticity_token

  def show
    url = "/" + params[:url].join("/")
    @node = Node.find_by_url(url)
    
    raise ActiveRecord::RecordNotFound if @node.nil?
    
    if @node.is_a? TextNode
      begin
        render :text => @node.formatted(self), :layout => @node.layout
      rescue Liquid::SyntaxError => @exception
        render :template => 'text_nodes/syntax_error'
      end
    elsif @node.is_a? FileNode
      send_data(@node.resource.path, :disposition => "inline", :type => @node.resource.content_type)
    end
  end
end
