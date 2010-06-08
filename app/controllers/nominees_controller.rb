class NomineesController < ApplicationController

  layout 'application'

  # GET /nominees
  # GET /nominees.xml
  def index
    if params[:election_event]
      @nominees = Nominee.find(:all, :conditions => { :election_event_id => params[:election_event]})
      @election_event = ElectionEvent.find(params[:election_event])
    else
      @election_event = ElectionEvent.find(:first, :conditions =>
          ["date >= ?", DateTime.now - 1.day],
        :order => "date asc")

      if @election_event.nil?
        @nominees = true; # Fulhack så att tillhörande meny syns
        render :action => "empty"
        return
      end
      
      @nominees = Nominee.find(:all, :conditions => {
          :election_event_id => @election_event.id
        })
      @last_change = Nominee.find(:first, :conditions => {
          :election_event_id => @election_event.id
        }, :order => "updated_at desc"
        ).try(:updated_at)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @nominees }
    end
  end

  # GET /nominees/1
  # GET /nominees/1.xml
  def show
    @nominee = Nominee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nominee }
    end
  end

  # GET /nominees/new
  # GET /nominees/new.xml
  def new
    @nominee = Nominee.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nominee }
    end
  end

  # GET /nominees/1/edit
  def edit
    @nominee = Nominee.find(params[:id])
    @nominee.person_id = Person.find(@nominee.person_id).kth_username
  end

  # POST /nominees
  # POST /nominees.xml
  def create
    @nominee = Nominee.new(params[:nominee])
    @nominee.person_id = Person.find_by_kth_username(params[:nominee][:person_id]).id

    respond_to do |format|
      if @nominee.save
        flash[:notice] = 'Nominee was successfully created.'
        format.html { redirect_to(@nominee) }
        format.xml  { render :xml => @nominee, :status => :created, :location => @nominee }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nominee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /nominees/1
  # PUT /nominees/1.xml
  def update
    @nominee = Nominee.find(params[:id])

    params[:nominee][:person_id] = Person.find_by_kth_username(params[:nominee][:person_id]).id

    respond_to do |format|
      if @nominee.update_attributes(params[:nominee])
        flash[:notice] = 'Nominee was successfully updated.'
        format.html { redirect_to(@nominee) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nominee.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /nominees/1
  # DELETE /nominees/1.xml
  def destroy
    @nominee = Nominee.find(params[:id])
    @nominee.destroy

    respond_to do |format|
      format.html { redirect_to(nominees_url) }
      format.xml  { head :ok }
    end
  end

  def auto_complete_for_nominee_person_id
    find = params[:nominee][:person_id]
    if find
      @people = Person.find(:all,
        :conditions => ["kth_username like ? or first_name like ? or last_name like ?", "%#{find}%", "%#{find}%", "%#{find}%"]
      )
      render :partial => 'functionaries/user_names'
    else
      render :inline => "<ul></ul>"
    end
  end
end
