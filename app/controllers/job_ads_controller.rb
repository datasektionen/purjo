class JobAdsController < ApplicationController
  require_role 'pr', :except => [:index, :naringsliv_index]
  # GET /job_ads
  def index
    conditions = []
    conditions << "thesis = 1" if params[:thesis] 
    conditions << "part_time = 1" if params[:part_time] 
    conditions << "full_time = 1" if params[:full_time] 
    conditions = conditions.join(" OR ")
    @job_ads = JobAd.find(:all, :order => 'created_at DESC')

    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  # GET /job_ads/new
  def new
    @job_ad = JobAd.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /job_ads/1/edit
  def edit
    @job_ad = JobAd.find(params[:id])
  end

  # POST /job_ads
  def create
    @job_ad = JobAd.new(params[:job_ad])
    @job_ad.created_by = Person.current

    respond_to do |format|
      if @job_ad.save
        flash[:notice] = 'Annonsen skapades'
        format.html { redirect_to(job_ads_path) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /job_ads/1
  def update
    @job_ad = JobAd.find(params[:id])

    respond_to do |format|
      if @job_ad.update_attributes(params[:job_ad])
        flash[:notice] = 'Annonsen uppdaterades'
        format.html { redirect_to(job_ads_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /job_ads/1
  def destroy
    @job_ad = JobAd.find(params[:id])
    @job_ad.destroy

    respond_to do |format|
      format.html { redirect_to(job_ads_path) }
    end
  end
  
end
