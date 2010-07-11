class NewsletterSectionsController < InheritedResources::Base
  belongs_to :newsletter
  
  def create
    create! { newsletter_path(@newsletter) }
  end
end
