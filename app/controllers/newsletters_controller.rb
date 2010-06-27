class NewslettersController < InheritedResources::Base
  
  def create
    create! { newsletters_path }
  end
end
