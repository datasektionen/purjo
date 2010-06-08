class TravelYearsController < ApplicationController
  require_role :admin

  def edit
    @year = TravelYear.find(params[:id])
  end
  
  def update
    @year = TravelYear.find(params[:id])
    
    if @year.update_attributes(params[:travel_year])
      flash[:notice] = 'Studs-år uppdaterat!'
      redirect_to("/")
    else
      render :action => "edit"
    end
  end

end
