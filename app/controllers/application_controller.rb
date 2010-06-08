# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include Ior::Security::AuthenticationSystem
  # Vill du installera ExceptionNotifier? Gör inte det. /spatrik

  before_filter :set_locale

  def set_locale
    I18n.locale = :sv
  end

  # Borrowed some code from the RoleRequirement gem
  include RoleRequirementSystem
  
  before_filter :save_return_to_url
  
  def save_return_to_url
    session[:return_to] = request.env['HTTP_REFERER']
  end
  
  def redirect_back_or_default(default)
    puts "return_to = #{session[:return_to]}"
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end
  
  
  helper :all # include all helpers, all the time
  before_filter :authenticate

  protect_from_forgery # :secret => '70750404a8baf26d530949457f3fdfb3'
  
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
