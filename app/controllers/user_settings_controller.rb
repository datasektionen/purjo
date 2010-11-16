class UserSettingsController < ApplicationController
  before_filter :load_person
  
  def edit_current
    raise IOR::Security::AccessDenied unless authorized?
    @person = Person.current
    @user_settings = @person.user_settings
    render :action => 'edit'
  end

  def show
    raise IOR::Security::AccessDenied unless authorized?
    @user_settings = @person.user_settings
    render :action => 'edit'
  end
  
  def create
    raise IOR::Security::AccessDenied unless authorized?
    @user_settings = @person.build_user_settings(params[:user_settings])
    @user_settings.save!
    redirect_to 
  end
  
  def update
    raise IOR::Security::AccessDenied unless authorized?
    @user_settings = @person.user_settings
    @user_settings.update_attributes(params[:user_settings])
    @user_settings.save!
    redirect_to :action => 'show'
  end
  
  private
  def load_person
    @person = Person.find_by_kth_username(params[:person_id])
  end
  
  def authorized?
    Person.current.admin? || Person.current == @person
  end
end
