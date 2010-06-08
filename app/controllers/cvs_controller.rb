class CvsController < ApplicationController
  include StudsAccess
  before_filter :load_travel_year

  def index
    cv_base = if params[:search]
      cv_base2 = @year.cvs
      
      search_terms(params[:search]).each do |term|
        cv_base2 = cv_base2.search(term)
      end
      
      cv_base2
    else
      @year.cvs.all
    end

    if params[:language].present?
      Cv::LANGUAGES.each do |language, abbr|
        cv_base = cv_base.send(language.downcase) if params[:language] == abbr
      end
    else
      # Default to swedish
      cv_base = cv_base.swedish
    end
    
    @cvs = if can_edit_cv?
      cv_base.all
    else
      cv_base.done
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @cvs }
    end
  end

  def show
    @cv = @year.cvs.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @cv }
    end
  end

  def new
    @cv = @year.cvs.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @cv }
    end
  end

  def edit
    @cv = @year.cvs.find(params[:id])
  end

  def create
    @cv = @year.cvs.new(params[:cv])

    respond_to do |format|
      if @cv.save
        flash[:notice] = 'Ett nytt CV skapades!'
        format.html { redirect_to(cv_path(@year.year, @cv)) }
        format.xml  { render :xml => @cv, :status => :created, :location => @cv }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @cv.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @cv = @year.cvs.find(params[:id])

    respond_to do |format|
      if @cv.update_attributes(params[:cv])
        flash[:notice] = 'CV uppdaterat!'
        format.html { redirect_to(cv_path(@year.year, @cv)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @cv.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @cv = @year.cvs.find(params[:id])
    @cv.destroy

    respond_to do |format|
      format.html { redirect_to(cvs_path(@year.year)) }
      format.xml  { head :ok }
    end
  end

  def login
    if request.post?
      if @year.company_users[params[:username]] && @year.company_users[params[:username]] == params[:password]
        session[:studs_username] = params[:username]
        session[:studs_access] = 'company'
        flash[:notice] = t("studs.cv.flash.welcome")
        redirect_to "/sektionen/studs/#{@year.year}/cvs"
      else
        flash[:error] = t("studs.cv.flash.unknown_user_or_pass")
        render :action => 'login'
      end
    else
      if Person.current.anonymous?
        render
      else
        if @year.project_members.include?(Person.current.kth_username)
          session[:studs_username] = Person.current.kth_username
          session[:studs_access] = 'project_member'
          redirect_to "/sektionen/studs/#{@year.year}/cvs"
        else
          flash[:error] = t("studs.cv.flash.no_access")
        end
      end
    end
  end

  def logout
    session[:studs_username] = nil
    session[:studs_access] = nil
    flash[:notice] = t("studs.cv.flash.logout")
    redirect_to current_studs_path
  end

  private
  
  def set_locale
    super
    I18n.locale = params[:language] if params[:language].present?
  end
  
  def current_studs_path
    "/sektionen/studs/#{@year.year}"
  end
  
  def render_with_correct_layout(options = nil, extra_options = {}, &block)
    layout = @year.layout
    
    options ||= {}
    
    render_without_correct_layout(options.merge(:layout => layout), extra_options, &block)
  end
  alias_method_chain :render, :correct_layout
  
  def can_edit_cv?
    session[:studs_access] == 'project_member'
  end
  helper_method :can_edit_cv?
  
  def load_travel_year
    @year = TravelYear.find_by_year(params[:year])
    raise ActiveRecord::RecordNotFound, "No studs year #{params[:year]} found" if @year.nil?
  end
  
  def search_terms(string)
    string, terms = find_quoted_strings(string)

    string.split(/\s+/) + terms
  end
  
  QUOTED_STRING_REGEXP = /"(.*?)"/
  
  def find_quoted_strings(string)
    original_string = string.dup
    matches = []
    while (match = QUOTED_STRING_REGEXP.match(string)) != nil
      matches << match.captures[0] 
      string = match.post_match
    end
    [original_string.gsub(QUOTED_STRING_REGEXP, ""), matches]
  end
  
end

