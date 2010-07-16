require File.dirname(__FILE__) + '/acceptance_helper'

feature "newsletter system" do
  include Authentication
  include Rails.application.routes.url_helpers
  
  background do
    @hominid = Ior::Hominid::TestBase.new(:api_key => 'cafebabe')
    Ior::Hominid::TestBase.stub(:new).and_return(@hominid)
    Factory(:root_page)
  end
  
  scenario "creating a new news letter" do
    login_as(:admin_user)
    visit newsletters_path
    click "Nytt nyhetsbrev"
    fill_in 'Ämne', :with => 'Nyhetsbrevet'
    click "Skapa Newsletter"
    
    #page.should have_success_message
    current_path.should == newsletters_path
    page.should have_content("Nyhetsbrevet")
  end
  
  scenario "Adding a section to a news letter" do
    login_as(:ture_teknolog)
    
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
  
  scenario "test sending a newsletter" do
    login_as(:admin_user)
    
    newsletter = Factory(:newsletter_march_2010)
    
    visit newsletters_path
    within("tr#newsletter_#{newsletter.id}") do
      click "Testutskick"
    end
    
    page.should have_content("Datasektionen Template")
    
    within "div#test_send" do
      fill_in 'Email', :with => 'kalle@example.com'
    end
    
    click "Skicka testutskick"
    
    page.should_not have_content("Ett fel uppstod vid testutskick!")
    
    current_path.should == newsletters_path
  end
  
  scenario "sending a news letter" do
    login_as(:admin_user)
    newsletter = Factory(:newsletter_march_2010)
    
    visit newsletters_path
    within("tr#newsletter_#{newsletter.id}") do
      click "Skicka nyhetsbrev"
    end
    
    page.should have_content("Datasektionen Template")
    
    list_select = find_field("List").node
    option_texts = list_select.css("option").map { |o| o.text }
    option_texts.should include("Ior")
    option_texts.should include(Ior::Hominid::TestBase::ListName)
    
    select Ior::Hominid::TestBase::ListName, :from => 'List'
    
    click "Skicka nyhetsbrev"

    page.should_not have_content("Ett fel uppstod vid testutskick!")
    
    current_path.should == newsletters_path
  end
  
  scenario "trying to send an already sent newsletter" do
    login_as(:admin_user)
    
    newsletter = Factory(:newsletter_march_2010)
    
    visit newsletters_path
    within("tr#newsletter_#{newsletter.id}") do
      page.should have_content("Skicka nyhetsbrev")
    end
    
    click "Skicka nyhetsbrev" # Länken
    select Ior::Hominid::TestBase::ListName, :from => 'List'
    click "Skicka nyhetsbrev" # Knappen
    
    visit newsletters_path
    
    lambda { 
      within("tr#newsletter_#{newsletter.id}") do
        click "Skicka nyhetsbrev"
      end
    }.should raise_error(Capybara::ElementNotFound)
    
  end
end