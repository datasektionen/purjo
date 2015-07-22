class NewslettersController < InheritedResources::Base
  require_role :admin, :for_all_except => [:index, :show, :admin]
  require_role :editor, :only => :admin

  before_filter :menu_items

  def index
    @newsletters = Newsletter.published.paginate(:page => params[:page])
  end

  def admin
    @newsletters = Newsletter.paginate(:page => params[:page])
  end

  def show
    if Person.current.has_role?(:editor)
      @newsletter = Newsletter.find(params[:id])
    else
      @newsletter = Newsletter.published.find(params[:id])
    end
  end
  
  def create
    create! { newsletters_path }
  end

  protected
  def menu_items
    @menu_items=TextNode.find_by_url("/sektionen/nyhetsbrev").menu[:items]
  end
  
  private
  def collection
    @newsletters ||= end_of_association_chain.paginate(:page => params[:page])
  end
  
end
