class MySettingsController < ApplicationController
  before_filter :find_person

  def show
    @settings = @person.my_settings
  end
  
  def edit
    @settings = @person.my_settings
  end
  
  def update

    if @person.update_attributes(params[:person])
      flash[:notice] = "Min purjo-inställningar sparade!"
      redirect_to(person_settings_path(@person))
    else
      flash[:error] = "Nånting gick fel. Hur lyckades du?"
      render :action => 'edit'
    end
  end

  private
  def find_person
    @person = Person.find_by_kth_username(params[:person_id])
  end
end