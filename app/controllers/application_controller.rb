class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'
  include Ior::Security::AuthenticationSystem
  include RoleRequirementSystem
  before_filter :authenticate
  before_filter :set_locale
  before_filter :save_return_to_url

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
  def rescue_action_in_public(exception)
    @exception = exception
    params[:format] = nil
    case exception
    when ActiveRecord::RecordNotFound
      render :file => 'errors/file_not_found', :layout => true
    when Ior::Security::AccessDenied
      render :file => 'errors/access_denied', :layout => true
    when SyntaxError
      render :file => 'errors/syntax_error', :layout => true
    else
      render :file => 'errors/other_error', :layout => true
      params_to_send = (respond_to? :filter_parameters) ? filter_parameters(params) : params
      
      Exceptional.handle(exception, self, request, params_to_send)
      
    end
  end
  
  def local_request?
    super && !params[:debug]
  end
end
