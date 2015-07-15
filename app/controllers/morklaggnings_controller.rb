# encoding: utf-8
class MorklaggningsController < ApplicationController
  require_role :admin

  layout 'application'

  def index
    @morklaggnings = Morklaggning.find(:all)
    #Vi har även new-funktionaliteten på indexsidan
    @morklaggning = Morklaggning.new
    #Och även funktionalitet för att ändra intervall
    start = Settings.find_by_key("morklaggning_start_date")
    stop = Settings.find_by_key("morklaggning_end_date")
    if start and stop
      @start = start.value.split('-').map { |i| i.to_i }
      @stop = stop.value.split('-').map { |i| i.to_i }
    else
      date = DateTime.now
      @start = [date.year, date.mon, date.mday];
      @stop = [date.year, date.mon, date.mday];
    end

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /morklaggnings/1/edit
  def edit
    @morklaggning = Morklaggning.find(params[:id])
  end

  # POST /morklaggnings
  # POST /morklaggnings.xml
  def create
    if params[:interval].nil? then
      @morklaggning = Morklaggning.new(params[:morklaggning])

      respond_to do |format|
        if @morklaggning.save
          flash[:notice] = "Ny mörkläggning skapad."
          format.html { redirect_to(morklaggnings_url) }
        else
          format.html { render :action => "new" }
        end
      end
    else
      startdate = params[:interval]["start(1i)"] +"-"+ params[:interval]["start(2i)"] +"-"+ params[:interval]["start(3i)"]
      stopdate = params[:interval]["stop(1i)"] +"-"+ params[:interval]["stop(2i)"] +"-"+ params[:interval]["stop(3i)"]
      start = Settings.find_or_create_by_key("morklaggning_start_date")
      start.value = startdate
      start.save
      stop = Settings.find_or_create_by_key("morklaggning_end_date")
      stop.value = stopdate
      stop.save
      respond_to do |format|
        flash[:notice] = "Mörkläggningsintervall sparat."
        format.html { redirect_to(morklaggnings_url) }
      end
    end
  end

  def update
    @morklaggning = Morklaggning.find(params[:id])

    respond_to do |format|
      if @morklaggning.update_attributes(params[:morklaggning])
        flash[:notice] = "Mörkläggningstabellen uppdaterad."
        format.html { redirect_to(morklaggnings_url) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @morklaggning = Morklaggning.find(params[:id])
    @morklaggning.destroy
        
    flash[:notice] = "Mörkläggningen borttagen."

    respond_to do |format|
      format.html { redirect_to(morklaggnings_url) }
    end
  end
end
