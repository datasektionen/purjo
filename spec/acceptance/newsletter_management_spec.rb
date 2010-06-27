require File.dirname(__FILE__) + '/acceptance_helper'

feature "newsletter system" do
  include Authentication
  include Rails.application.routes.url_helpers
  
  scenario "creating a new news letter" do
    visit newsletters_path
    click "Nytt nyhetsbrev"
    fill_in 'Namn', :with => 'Nyhetsbrevet'
    click "Skapa Newsletter"
    
    #page.should have_success_message
    current_path.should == newsletters_path
    page.should have_content("Nyhetsbrevet")
  end
  
  scenario "Adding a section to a news letter" do
    newsletter = Factory(:newsletter_march_2010)
    
    visit newsletters_path
    
    click "Mars 2010"
    
    click "Ny sektion"
    
    fill_in 'Rubrik', :with => 'Sektionsrubriken'
    fill_in 'Innehåll', :with => 'Den nya sektionen'
    
    click "Skapa Nyhetsbrevssektion"
    
    #page.should have_success_message
    current_path.should == newsletter_path(newsletter)
    page.should have_css("h3", :text => "Sektionsrubriken")
    page.should have_content("Den nya sektionen")
  end
  scenario "removing a section from a news letter"
  scenario "editing a news letter section"
  scenario "sending a news letter"
end