class NewslettersController < InheritedResources::Base
  require_role :admin, :for_all_except => [:index, :show, :admin]
  require_role :editor, :only => :admin

  def index
    @newsletters = Newsletter.published.sorted.paginate(:page => params[:page])
  end

  def admin
    @newsletters = Newsletter.all.paginate(:page => params[:page])
  end

  def show
    if Person.current.editor?
      @newsletter = Newsletter.find(params[:id])
    else
      @newsletter = Newsletter.published.find(params[:id])
    end
  end
  
  def create
    create! { newsletters_path }
  end
  
  private
  def collection
    @newsletters ||= end_of_association_chain.sorted.paginate(:page => params[:page])
  end
  
end
