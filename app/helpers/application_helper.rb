# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def admin_link(text, options)
    url = options.delete(:url)
    icon = options.delete(:icon)
    
    output = "<div>"
    if icon
      output += link_to(image_tag(icon, :class => 'icon'), url, options)
      output += " "
    end
    output += link_to(text, url, options) 
    output += "</div>"
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
    "http://" + request.env['HTTP_HOST'] + request.request_uri
  end
  
end
