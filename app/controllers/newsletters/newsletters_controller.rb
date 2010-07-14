class NewslettersController < InheritedResources::Base
  
  def create
    create! { newsletters_path }
  end
  
  private
  def collection
    @newsletters ||= end_of_association_chain.sorted.paginate(:page => params[:page], :per_page => 10)
  end
  
end
