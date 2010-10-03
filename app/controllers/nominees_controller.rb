class NomineesController < ApplicationController
  require_role :editor, :except => [:index]

  def index
    @menu_items=TextNode.find_by_url("/sektionen").menu[:items]
    if params[:election_event]
      @nominees = Nominee.find(:all, :conditions => {
          :election_event_id => params[:election_event]
        })
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

  def show
    @nominee = Nominee.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @nominee }
    end
  end

  def new
    @nominee = Nominee.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @nominee }
    end
  end

  def edit
    @nominee = Nominee.find(params[:id])
    if @nominee.person_id == -1
      @nominee.person_id = ''
    else
      @nominee.person_id = Person.find(@nominee.person_id).kth_username
    end
  end

  def create
    @nominee = Nominee.new(params[:nominee])
    person = Person.find_by_kth_username(params[:nominee][:person_id])
    
    # Hack så vi kan nominera en icke existerande person (tom inmatning)
    # så vi får skenet att poster utan nominerade kandidater syns under
    # /sektionen/val
    @nominee.person_id = person ? person.id : -1

    respond_to do |format|
      if @nominee.save
        flash[:notice] = 'Nominering skapad.'
        format.html { redirect_to(@nominee) }
        format.xml  { render :xml => @nominee, :status => :created, :location => @nominee }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @nominee.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @nominee = Nominee.find(params[:id])

    if not params[:nominee][:person_id].empty?
      params[:nominee][:person_id] = Person.find_by_kth_username(params[:nominee][:person_id]).id
    end

    respond_to do |format|
      if @nominee.update_attributes(params[:nominee])
        flash[:notice] = 'Nominering uppdaterad.'
        format.html { redirect_to(@nominee) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @nominee.errors, :status => :unprocessable_entity }
      end
    end
  end

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
