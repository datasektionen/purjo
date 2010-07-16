class UserSettingsController < ApplicationController
  before_filter :load_person
  
  def show
    @user_settings = @person.user_settings
  end
  
  def create
    @user_settings = @person.build_user_settings(params[:user_settings])
    @user_settings.save!
    redirect_to 
  end
  
  def edit
    @user_settings = @person.user_settings
  end
  
  def update
    @user_settings = @person.user_settings
    @user_settings.update_attributes(params[:user_settings])
    @user_settings.save!
  end
  
  def load_person
    @person = Person.find_by_kth_username(params[:person_id])
  end
end
