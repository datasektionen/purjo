class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  include Ior::Security::AuthenticationSystem
  include RoleRequirementSystem
  before_filter :authenticate
  before_filter :set_locale
  before_filter :save_return_to_url
  
  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  rescue_from Ior::Security::AccessDenied, :with => :access_denied

  def set_locale
    I18n.locale = :sv
  end

  def save_return_to_url
    session[:return_to] = request.env['HTTP_REFERER']
  end
  
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  protected
  def not_found
    render :file => 'errors/file_not_found', :layout => true
  end
  
  def access_denied
    render :file => 'errors/access_denied', :layout => true
  end
  
  def local_request?
    super && !params[:debug]
  end
end
