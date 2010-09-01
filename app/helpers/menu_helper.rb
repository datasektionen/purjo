module MenuHelper
  def menu(&block)
    
    tree = yield MenuTreeBuilder.new
    
    #concat('<ul class="depth1">', block.binding)
    #yield MenuBuilder.new(block.binding, self)
    #concat('</ul>', block.binding)
    
    # fixme: REQUEST_URI blir /post_contents/new på haagen-dazs oberoende sida, varför?
    begin
      uri = URI.parse(request.env['REQUEST_URI'])
    rescue URI::InvalidURIError => e
      uri = URI.parse("http://www.d.kth.se")
    end
    
    sought = Node.sanitize_url(uri.path).split(/\//).reject { |t| t.nil? or t.empty? or t == 'purjo' } # ok, hackigt. :)
    #result = find_selected_with_ugly_hack_of_death(tree, sought)
    result = find_selected(tree, sought)
    
    html = []
    html << %{<ul class="depth1">}
    
    tree.each do |first_level_item|
         
      if(first_level_item[:absolute]) 
        html << %{ <li class="dropdown open"><a href="#{first_level_item[:ref]}" class="depth1">#{first_level_item[:text]}</a>}
      else
        html << %{ <li class="dropdown open"><a href="/#{first_level_item[:ref]}" class="depth1">#{first_level_item[:text]}</a>}
      end
                  
      html << " <ul>"
      
      first_level_item[:children].each do |second_level_item|
        
        if second_level_item[:children].empty?
          css = ""
          if second_level_item[:selected]
            css = %{ class="selected"}
          end
        elsif second_level_item[:open]
          css = %{ class="dropdown open"}
        else
          css = %{ class="dropdown closed"}
        end
        
        html << %{  <li#{css}>}
        
        if(second_level_item[:absolute])
          html << %{   <a href="#{second_level_item[:ref]}">#{second_level_item[:text]}</a>}
        else
          html << %{   <a href="/#{first_level_item[:ref]}/#{second_level_item[:ref]}">#{second_level_item[:text]}</a>}
        end
        
        if not second_level_item[:children].empty?
          html << "  <ul>"
          second_level_item[:children].each do |third_level_item|
            css = ""
            if third_level_item[:selected]
              css = %{ class="selected"}
            end
            if(third_level_item[:absolute])
              html << %{   <li#{css}><a href="#{third_level_item[:ref]}">#{third_level_item[:text]}</a></li>}
            else
              html << %{   <li#{css}><a href="/#{first_level_item[:ref]}/#{second_level_item[:ref]}/#{third_level_item[:ref]}">#{third_level_item[:text]}</a></li>}
            end
          end
          html << "  </ul>"
        end
        html << "  </li>"
        
      end
      
      html << " </ul>"
      
    end
    
    html << "</ul>"
    
    html = html.join "\n"
    
    concat(html.html_safe)
    
  end
  
  def find_selected(tree, sought, index = 0)  
    if sought.nil?
      return false
    end
    
    tree.each do |child|
      if child[:ref] == sought[index]
        if index == sought.length - 1
          child[:open] = true
          child[:selected] = true;
          return true
        elsif child.has_key? :children
          child[:open] = true
          found = find_selected(child[:children], sought, index + 1)
          if(! found) 
            child[:selected] = true
          end
          
          return true
        end
      end
      
      
    end
    return false
  end
  
  def find_selected_with_ugly_hack_of_death(tree, sought, index = 0)  
    tree.each do |child|
      child[:open] = true
      find_selected_with_ugly_hack_of_death(child[:children], sought, index + 1)
    end
    return true
  end

  def subnav_menu_item(title,url)
    if request.fullpath == url
      haml_tag :li, :class=>"current" do
        haml_concat link_to(title,url)
      end
    else
      haml_tag :li do
        haml_concat link_to(title,url)
      end
    end
  end
  
  
  
  class MenuTreeBuilder
    def initialize
      @tree = []
    end
    def section(text, ref, options = {}, &block)
      hash = {
        :text => text,
        :ref => ref,
        :children => []
      }
      hash[:children] = yield(MenuSectionTreeBuilder.new(0)) || []
      
      @tree << hash
      @tree
    end
  end
  
  
  class MenuSectionTreeBuilder
    def initialize(level)
      @section = []
      @level = level
    end
    
    def section(text, ref, options = {}, &block)
      hash = {
        :text => text,
        :ref => ref,
        :children => []
      }
      hash[:children] = yield(MenuSectionTreeBuilder.new(0)) || []
      
      @section << hash
      @section
    end
    
    def menu_item(text, ref, options = {})
      @section << {
        :text => text,
        :ref => ref,
        :children => []
      }
      
      if ref.index("://") || ref[0..0] == "/"
        @section.last[:absolute] = true
      end
      
      @section
    end
  end
end
