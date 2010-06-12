module NavigationHelpers
  # Put here the helper methods related to the paths of your applications
  
  def homepage
    "/"
  end
  
  def current_path
    URI.parse(current_url).select(:path, :query).compact.join('?')
  end
end

Rspec.configuration.include(NavigationHelpers)
