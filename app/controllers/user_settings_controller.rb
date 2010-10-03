class UserSettingsController < ApplicationController
  before_filter :load_person
  before_filter :check_access
  
  def edit_current
    @person = Person.current
    @user_settings = @person.user_settings
    render :action => 'edit'
  end

  def show
    @user_settings = @person.user_settings
    render :action => 'edit'
  end
  
  def create
    @user_settings = @person.build_user_settings(params[:user_settings])
    @user_settings.save!
    redirect_to 
  end
  
  def update
    @user_settings = @person.user_settings
    @user_settings.update_attributes(params[:user_settings])
    @user_settings.save!
    redirect_to :action => 'show'
  end
  
  private
  def load_person
    @person = Person.find_by_kth_username(params[:person_id])
  end
  
  def check_access
    if !(Person.current.admin? || Person.current == @person)
      raise Ior::Security::AccessDenied
    end
  end
end
