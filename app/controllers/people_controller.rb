class PeopleController < ApplicationController
  require_role "admin", :except => [:show, :edit, :update]

  def index
    @people = Person.all(:include => :roles).paginate(:page => params[:page])
  end

  def show
    @person = Person.find_by_kth_username(params[:id])
    raise ActiveRecord::RecordNotFound if @person.nil?
  end
  
  def edit
    @person = Person.find_by_kth_username(params[:id])
  end

  def update
    #Initialize values to nil, [] or {} unless set
    params[:person] = {} unless params[:person]
    #This might not be needed
    params[:person] = params[:person].each_value { |item| item = nil unless item }
    params[:person][:role_ids] = [] unless params[:person][:role_ids] 
    
    @person = Person.find_by_kth_username(params[:id])

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
      logger.info "\nOK!\n"
    end

    logger.info "Address = " + params[:person][:address].to_s + "\n"

    redirect_to @person
  end

  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    redirect_to(people_url)
  end
  
  def xfinger

    # T.ex. drifvarna laddas med id-nummer
    if params[:id].match(/\d+/)
      @person = Person.find(params[:id])
    else
      @person = Person.find_by_kth_username(params[:id])
    end
    
    raise ActiveRecord::RecordNotFound if @person.nil?

    xfinger = nil
    if @person.homedir
      if @person.file_ok(@person.homedir + "/.bild")
          xfinger = @person.homedir + "/.bild"
      elsif @person.file_ok('/afs/nada.kth.se/misc/hacks/graphic/bitmaps/xfinger' + @person.homedir.gsub(/.*\/home/,''))
          xfinger = '/afs/nada.kth.se/misc/hacks/graphic/bitmaps/xfinger' + @person.homedir.gsub(/.*\/home/,'')
      end
    end

    if xfinger.nil?
      xfinger = "public/images/xfinger-notfound.png"
    end

    send_file(xfinger, :disposition => "inline")
  end
  
end
