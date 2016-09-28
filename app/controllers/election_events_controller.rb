# encoding: utf-8
class ElectionEventsController < ApplicationController

  layout 'application'
  require_role "editor"

  # GET /election_events
  # GET /election_events.xml
  def index
    @election_events = ElectionEvent.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @election_events }
    end
  end

  # GET /election_events/1
  # GET /election_events/1.xml
  def show
    @election_event = ElectionEvent.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @election_event }
    end
  end

  # GET /election_events/new
  # GET /election_events/new.xml
  def new
    @election_event = ElectionEvent.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @election_event }
    end
  end

  # GET /election_events/1/edit
  def edit
    @election_event = ElectionEvent.find(params[:id])
  end

  # POST /election_events
  # POST /election_events.xml
  def create
    @election_event = ElectionEvent.new(params[:election_event])

    respond_to do |format|
      if @election_event.save
        flash[:notice] = 'Valtillfälle skapat.'
        format.html { redirect_to(@election_event) }
        format.xml  { render :xml => @election_event, :status => :created, :location => @election_event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @election_event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /election_events/1
  # PUT /election_events/1.xml
  def update
    @election_event = ElectionEvent.find(params[:id])

    respond_to do |format|
      if @election_event.update_attributes(params[:election_event])
        flash[:notice] = 'Valtillfälle uppdaterat.'
        format.html { redirect_to(@election_event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @election_event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /election_events/1
  # DELETE /election_events/1.xml
  def destroy
    @election_event = ElectionEvent.find(params[:id])
    @nominees = Nominee.find(:all, :conditions => { :election_event_id => params[:id]})
    
    respond_to do |format|
      if @nominees.empty?
        flash[:notice] = 'Valtillfället är borttaget.'
        @election_event.destroy
        format.html { redirect_to(election_events_path) }
      else
        flash[:notice] = 'Du kan inte ta bort ett valtillfälle med nomineringar.'
        format.html { redirect_to(@election_event) }
      end
    end

  end
end
