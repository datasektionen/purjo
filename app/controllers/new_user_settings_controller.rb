class NewUserSettingsController < ApplicationController
  before_filter :load_person
  def create
    @new_user_settings = NewUserSettings.new(@person, params[:new_user_settings])
    @new_user_settings.save!
    redirect_to root_path
  end
  
  def load_person
    @person = Person.find_by_kth_username(params[:person_id])
  end
end
