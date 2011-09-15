require 'ior/kth/users_groups/login_service'

class SessionsController < ApplicationController
  
  def show
    render :text => "show"
  end
  
  def new
    service = Ior::KTH::UsersGroups::LoginService.new(new_sessions_url())
    
    if params[:ticket]
      ugid = service.validate_ticket(params[:ticket])
      
      if ugid
        person = Person.unscoped.find_or_import(ugid)

        if not person.kth_account
          person.kth_account = KthAccount.create(:ugid => ugid)
          person.save!
        end
        
        session[:person_id] = person.id
        redirect_to(session[:return_url] || '/')
      else
        raise SecurityError, "Unable to authenticate ticket"
      end
    else
      session[:return_url] = params[:return_url]
      redirect_to service.login_url
    end
  end
  
  def destroy
    session[:person_id] = nil
    session[:return_url] = nil
    
    redirect_to params[:return_url] || '/'
  end
  
end
