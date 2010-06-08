class ListsController < ApplicationController
  require_role 'editor'
  
  # GET /lists
  # GET /lists.xml
  def index
    if Person.current.admin?
      @lists = List.all
    else
      @lists = List.with_permission(Person.current)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @lists }
    end
  end

  # GET /lists/1
  # GET /lists/1.xml
  def show
    @list = List.find(params[:id])
    if !@list.has_permission?(Person.current)
      raise Ior::Security::AccessDenied
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @list }
    end
  end

  # GET /lists/new
  # GET /lists/new.xml
  def new
    @list = List.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @list }
    end
  end

  # GET /lists/1/edit
  def edit
    @list = List.find(params[:id])
    if !@list.has_permission?(Person.current)
      raise Ior::Security::AccessDenied
    end
    
    @list_field = ListField.new
  end

  # POST /lists
  # POST /lists.xml
  def create
    @list = List.new(params[:list])
    @list.creator = Person.current
    
    respond_to do |format|
      if @list.save
        flash[:notice] = 'Listan skapades.'
        format.html { redirect_to lists_path }
        format.xml  { render :xml => @list, :status => :created, :location => @list }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /lists/1
  # PUT /lists/1.xml
  def update
    @list = List.find(params[:id])
    if !@list.has_permission?(Person.current)
      raise Ior::Security::AccessDenied
    end

    respond_to do |format|
      if @list.update_attributes(params[:list])
        flash[:notice] = 'Listan uppdaterades.'
        format.html { redirect_to lists_path }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @list.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /lists/1
  # DELETE /lists/1.xml
  def destroy
    @list = List.find(params[:id])
    if !@list.has_permission?(Person.current)
      raise Ior::Security::AccessDenied
    end
    @list.destroy
    
    respond_to do |format|
      format.html { redirect_to(lists_url) }
      format.xml  { head :ok }
    end
  end
end
