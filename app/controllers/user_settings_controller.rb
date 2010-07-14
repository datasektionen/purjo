class UserSettingsController < ApplicationController
  before_filter :load_person
  def create
    @user_settings = UserSettings.new(@person, params[:user_settings])
    @user_settings.save!
    redirect_to root_path
  end
  
  def load_person
    @person = Person.find_by_kth_username(params[:person_id])
  end
end
