class FunctionariesController < ApplicationController
  layout 'application'
  require_role "editor", :except => [:show, :index]

  # GET /functionaries
  # GET /functionaries.xml
  def index
    @menu_items=TextNode.find_by_url("/sektionen").menu[:items]
    @functionaries = Functionary.active.joins(:chapter_post).order("chapter_posts.name")

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @functionaries }
    end
  end

  # GET /functionaries/1
  # GET /functionaries/1.xml
  def show
    @menu_items=TextNode.find_by_url("/sektionen").menu[:items]
    @functionary = Functionary.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @functionary }
    end
  end

  # GET /functionaries/new
  # GET /functionaries/new.xml
  def new
    today = Date.today.month

    # [1] 2 3> <4 5 6 [7] 8 9> <10 11 12
    if today < 4 or today > 9
      @functionary = Functionary.new(
        :active_from => Date.new(Date.today.year,01,01),
        :active_to => Date.new(Date.today.year,12,31)
      )
    else
      @functionary = Functionary.new(
        :active_from => Date.new(Date.today.year,07,01),
        :active_to => Date.new(Date.today.year + 1,06,30)
      )
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @functionary }
    end
  end

  # GET /functionaries/1/edit
  def edit
    @functionary = Functionary.find(params[:id])
    if @functionary.person
      @functionary.person_id = @functionary.person.kth_username
    else
      @functionary.person_id = ""
    end
  end

  # POST /functionaries
  # POST /functionaries.xml
  def create
    @functionary = Functionary.new(params[:functionary])
    if params[:functionary][:person_id] != ""
      @functionary.person_id = Person.find_by_kth_username(params[:functionary][:person_id]).id
    end

    respond_to do |format|
      if @functionary.save
        flash[:notice] = 'Functionary was successfully created.'
        format.html { redirect_to(@functionary) }
        format.xml  { render :xml => @functionary, :status => :created, :location => @functionary }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @functionary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /functionaries/1
  # PUT /functionaries/1.xml
  def update
    @functionary = Functionary.find(params[:id])

    if params[:functionary][:person_id] != ""
      params[:functionary][:person_id] = Person.find_by_kth_username(params[:functionary][:person_id]).id
    else
      params[:functionary][:person_id] = ""
    end

    respond_to do |format|
      if @functionary.update_attributes(params[:functionary])
        flash[:notice] = 'Functionary was successfully updated.'
        format.html { redirect_to(@functionary) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @functionary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /functionaries/1
  # DELETE /functionaries/1.xml
  def destroy
    @functionary = Functionary.find(params[:id])
    @functionary.destroy

    respond_to do |format|
      format.html { redirect_to(functionaries_url) }
      format.xml  { head :ok }
    end
  end

  def auto_complete_for_functionary_person_id
    find = params[:functionary][:person_id]
    if find
      @people = Person.find(:all, 
        :conditions => ["kth_username like ? or first_name like ? or last_name like ?", "%#{find}%", "%#{find}%", "%#{find}%"]
      )
      render :partial => 'user_names'
    else
      render :inline => "<ul></ul>"
    end
  end

end
