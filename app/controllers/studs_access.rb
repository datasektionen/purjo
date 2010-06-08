module StudsAccess
  def self.included(base)
    base.before_filter :verify_access, :except => [:login]
  end

  def verify_access
    redirect_to :controller => 'cvs', :action => 'login' unless session[:studs_username]
  end
  
end
