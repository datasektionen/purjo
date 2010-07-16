class NewsletterSectionsController < InheritedResources::Base
  require_role :editor
  
  belongs_to :newsletter
  
  def create
    create! { newsletter_path(@newsletter) }
  end
end
