require File.dirname(__FILE__) + '/acceptance_helper'

feature "user settings" do
  include Authentication
  include Rails.application.routes.url_helpers
  
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
  
  scenario "unsubscribing from newsletter via purjo" do
    ture = login_as(:ture_teknolog)
    ture.newsletter_subscriptions.create!
    ture.newsletter_subscriptions.first.process!
    
    visit person_user_settings_path(ture)
    
    click "Ändra inställningar"
    
    find_field("Nyhetsbrev")['checked'].should == true
    
    uncheck "Nyhetsbrev"
    click "Spara inställningar"
    ture.newsletter_subscriptions.active.should == nil
    
  end
  
end