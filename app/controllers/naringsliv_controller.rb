class NaringslivController < ApplicationController
  def index
    conditions = []
    conditions << "thesis = 1" if params[:thesis] 
    conditions << "part_time = 1" if params[:part_time] 
    conditions << "full_time = 1" if params[:full_time] 
    conditions = conditions.join(" OR ")
    @job_ads = JobAd.where(conditions)
    render :layout => 'diy'
  end
  
end