require File.dirname(__FILE__) + '/acceptance_helper'

feature "calendar" do
  scenario "viewing the empty calendar" do
    Timecop.freeze(Time.local(2010, 10, 27, 14, 17, 0))
    visit "/kalender"
    
    page.should have_content("Oktober")
  end
  
  scenario "getting the ICS format of the calendar" do
    Factory(:tentapub_calendar_post)
    
    visit "/kalender.ics"
    
    body = page.body
    body.should include("BEGIN:VCALENDAR")
  end
end