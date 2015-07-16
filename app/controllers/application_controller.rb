require 'ior/security/authentication_system'
require 'ior/security/role_requirement_system'

class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'text_node_default'
  include Ior::Security::AuthenticationSystem
  include Ior::Security::RoleRequirementSystem
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
    render :file => 'errors/file_not_found.html', :layout => true, :status => 404
  end

  def access_denied
    render :file => 'errors/access_denied.html', :layout => true, :status => 403
  end

  def local_request?
    super && !params[:debug]
  end
end
