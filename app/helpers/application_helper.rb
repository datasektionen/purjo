module ApplicationHelper
  def admin_link(text, options)
    url = options.delete(:url)
    icon = options.delete(:icon)
    
    content_tag(:li) do
      output = ""
      if icon
        output += link_to(image_tag(icon, :class => 'icon'), url, options)
        output += " "
      end
      output += link_to(text, url, options) 
      output
    end
  end
  
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
    css_class = (request.request_uri =~ regex) ? 'active' : ''
    
    content_tag(:li, :class => css_class) do
      link_to text, path
    end
  end
end
