require File.dirname(__FILE__) + '/acceptance_helper'

feature "the news system" do
  include Authentication
  before do
    Factory(:admin_role)
    Factory(:editor_role)
    
    [AnonymousPerson, Person].each do |auth_class| 
      auth_class.class_eval do
        Role.all.each do |role|
          define_method "#{role.to_s}?" do 
            has_role?(role.to_s)
          end
        end
      end
    end
    
  end
  scenario "viewing the news page" do
    Factory(:naringslivsgruppen_tag)
    nlg_news = Factory(:nlg_news_post)
    
    visit "/"
    
    page.should have_content("Näringslivsgruppsnyhet")
    
    within("div#news_post_#{nlg_news.id} .categories") do
      page.should have_content("Näringslivsgruppen")
    end
  end
  
  scenario "adding news item" do
    Factory(:root_page)
    Factory(:naringslivsgruppen_tag)
    login_as(:admin_user)
    
    visit "/"
    
    click_admin_link "Ny nyhet-/kalender-post"
    
    fill_in "Name", :with => "Todays News"
    fill_in "Content", :with => "Todays news contents"
    check "Näringslivsgruppen"
    check "Nyhet"
    fill_in "Visas till", :with => 1.day.ago.to_s
    
    click "Create Post"
  end
end