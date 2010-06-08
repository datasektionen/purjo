class NoisesController < ApplicationController
layout 'application'
  # GET /noises
  # GET /noises.xml
  def index
    @noises = Noise.all
    redirect_to "/"
  end

  # GET /noises/1
  # GET /noises/1.xml
  def show
    @noise = Noise.find(params[:id])

    redirect_to post_url(@noise.post_id)
   end

  # GET /noises/new
  # GET /noises/new.xml
  def new
    @noise = Noise.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @noise }
    end
  end

  # GET /noises/1/edit
  def edit
    @noise = Noise.find(params[:id])
  end

  # POST /noises
  # POST /noises.xml
  def create
    @noise = Noise.new(params[:noise])
    @noise.person_id = Person.current.id
    if @noise.save
	    flash[:notice] = 'Kommentar skapad.'
    else
	    flash[:notice] = 'Kommentar gick inte att skapa.'
    end
    redirect_to post_url(@noise.post_id)
  end

  # PUT /noises/1
  # PUT /noises/1.xml
  def update

    @noise = Noise.find(params[:id])
    if @noise.editable?
      if @noise.update_attributes(params[:noise])
        flash[:notice] = 'Kommentar uppdaterad.'
      end
    else
	    flash[:notice] = 'Du får endast redigera dina egna kommentarer'
    end
    redirect_to post_url(@noise.post_id)
  end

  # DELETE /noises/1
  # DELETE /noises/1.xml
#  def destroy
#    @noise = Noise.find(params[:id])
#    @noise.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(noises_url) }
#      format.xml  { head :ok }
#    end
#  end
end
