class StudsNodesController < NodesController
  include StudsAccess
  before_filter :load_year
  
  def show
    params[:url] = ["sektionen", "studs", @year.year, "internt"] + params[:url]
    super
  end
  
  private
  
  def load_year
    @year = TravelYear.find_by_year(params[:year])
  end
end