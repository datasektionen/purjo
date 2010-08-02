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
        flash[:notice] = 'ElectionEvent was successfully created.'
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
        flash[:notice] = 'ElectionEvent was successfully updated.'
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
    @election_event.destroy

    respond_to do |format|
      format.html { redirect_to(election_events_url) }
      format.xml  { head :ok }
    end
  end
end
