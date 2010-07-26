class NewsletterSectionsController < InheritedResources::Base
  require_role :admin, :only => [:edit, :update, :delete]
  require_role :editor
  
  belongs_to :newsletter

  # TODO: varför vill inte InheritedResources göra det här åt mig? =(
  def edit
  end

  def update
    update! { newsletter_path(@newsletter) }
  end

  def create
    create! { newsletter_path(@newsletter) }
  end
end
