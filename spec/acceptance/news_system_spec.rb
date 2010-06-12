require File.dirname(__FILE__) + '/acceptance_helper'

feature "the news system" do
  
  before do
    Factory(:admin_role)
    Factory(:editor_role)
    
    AnonymousPerson.class_eval do
      Role.all.each do |role|
        define_method "#{role.to_s}?" do 
          has_role?(role.to_s)
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
end