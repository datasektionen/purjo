class NewsletterSectionsController < InheritedResources::Base
  require_role :admin, :only => [:destroy]
  require_role :editor
  
  belongs_to :newsletter

  def update
    update! { newsletter_path(@newsletter) }
  end

  def create
    create! { newsletter_path(@newsletter) }
  end

  def destroy
    destroy! { newsletter_path(@newsletter) }
  end
end
