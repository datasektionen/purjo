module ApplicationHelper
  def javascript(*scripts)
    content_for(:head) do
      javascript_include_tag(*scripts)
    end
  end
  
  def stylesheet(*css)
    content_for(:head) do
      stylesheet_link_tag(*css)
    end
  end
  
  def current_url
    "http://" + request.raw_host_with_port + request.fullpath
  end
  
  def top_navigation_link(text, path, regex)
    css_class = (request.fullpath =~ regex) ? 'active' : ''
    
    content_tag(:li, :class => css_class) do
      link_to text, path
    end
  end
  
  def side_link(*options)
    @view_menus = Array.new unless @view_menus
    @view_menus.push options
  end
end
