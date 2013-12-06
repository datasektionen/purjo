require File.dirname(__FILE__) + '/acceptance_helper'

feature "calendar" do
  scenario "getting the ICS format of the calendar" do
    Factory(:tentapub_calendar_post)

    visit "/kalender.ics"

    body = page.body
    body.should include("BEGIN:VCALENDAR")
  end

  scenario "getting the HTML format of the calendar" do
    visit "/kalender/2013/01"

    source = page.source
    source.should have_selector('td.week', :text => '1')
  end
end