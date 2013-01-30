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
  
  def top_navigation_link(text, path, regex, options = {})
    css_class = (request.fullpath =~ regex) ? 'active' : ''
    
    content_tag(:li, :class => css_class) do
      link_to text, path, options[:link_options]
    end
  end
  
  def nav_link(*options)
    @nav_menus = Array.new unless @nav_menus
    @nav_menus.push options
  end

  def admin_link(*options)
    @admin_menus = Array.new unless @admin_menus
    @admin_menus.push options
  end
end
