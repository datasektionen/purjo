module TitleHelper
  def title(title)
    @title = title
  end
  
  def render_title
    if @title.present?
      title = @title
    else
      title = if @node.present?
        if @node.is_a?(TextNode)
          @node.title.present? ? @node.title  : @node.name
        end
      end
    end
    
    if title.blank?
      title = "Konglig Datasektionen"
    else
      title += " – Konglig Datasektionen" 
    end
    title
  end
  
end