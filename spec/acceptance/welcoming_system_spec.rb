require File.dirname(__FILE__) + '/acceptance_helper'

feature "page management" do
  include Authentication
  
  background do
    @hominid = Ior::Hominid::TestBase.new(:api_key => 'cafebabe')
    Ior::Hominid::TestBase.stub(:new).and_return(@hominid)
  end
  
  scenario "visiting d.kth.se for the first time and signing up for the news letter" do
    
    norbert = login_as :norbert_nollan
    
    visit "/"
    
    page.should have_css("div#first_time_welcome")
    
    within "div#first_time_welcome" do
      check "Nyhetsbrev"
      click "Spara inställningar"
    end
    
    #@hominid.should_receive(:subscribe).with("deadbeef", 'norbert@example.com')
    #
    #Delayed::Worker.new.work_off
    
    # So this is the ugliest hack.
    Person.stub(:current).and_return(Person.find(norbert.id))
    
    visit "/"
    page.should_not have_css("div#first_time_welcome")
    norbert.should have(1).newsletter_subscription
  end
end