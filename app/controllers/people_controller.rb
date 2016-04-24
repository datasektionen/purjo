class PeopleController < ApplicationController
  require_role "admin", :except => [:show, :zfinger_image, :edit, :update]

  def index
    @people = Person.all(:include => :roles).paginate(:page => params[:page])
  end

  def show
    @person = Person.find_by_kth_username(params[:id])
    if !@person && Person.current.admin?
      @person = Person.unscoped.find_by_kth_username(params[:id])
    end

    raise ActiveRecord::RecordNotFound if @person.nil?
  end
  
  def edit
    # Allow editing of deleted users
    @person = Person.unscoped.find_by_kth_username(params[:id])
    return access_denied unless Person.current.admin? || Person.current.id == @person.id
  end

  def update
    #Initialize values to nil, [] or {} unless set
    params[:person] = {} unless params[:person]
    #This might not be needed
    params[:person] = params[:person].each_value { |item| item = nil unless item }
    params[:person][:role_ids] = [] unless params[:person][:role_ids] 
    
    @person = Person.unscoped.find_by_kth_username(params[:id])
    return access_denied unless Person.current.admin? || Person.current.id == @person.id

    if Person.current.admin? 
      #Admin updates everything, including roles
      @person.update_attributes(params[:person])
    elsif Person.current.id == @person.id
      #A person can change his own data, but not roles
      @person.address = params[:person][:address]
      @person.phone = params[:person][:phone]
      @person.homepage = params[:person][:homepage]
      @person.nickname = params[:person][:nickname]
      @person.startyear = params[:person][:startyear]
      @person.personalemail = params[:person][:personalemail]
      @person.msn = params[:person][:msn]
      @person.xmpp = params[:person][:xmpp]
      @person.save
    end

    redirect_to @person
  end

  def destroy
    # Soft delete
    @person = Person.unscoped.find(params[:id])
    @person.deleted = true
    @person.save

    redirect_to(people_url)
  end
  
end
