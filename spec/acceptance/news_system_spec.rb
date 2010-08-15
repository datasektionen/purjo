require File.dirname(__FILE__) + '/acceptance_helper'

feature "the news system" do
  include Authentication
  scenario "viewing the news page" do
    mock_roles
    Factory(:naringslivsgruppen_tag)
    nlg_news = Factory(:nlg_news_post)
    
    visit "/"
    
    page.should have_content("Näringslivsgruppsnyhet")
    
    within("div#post_#{nlg_news.id} .tags") do
      page.should have_content("NLG")
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
    fill_in 'Taggar', :with => "NLG"
    check "Nyhet"
    
    click "Skapa Post"
  end
  
  scenario "editing news post" do
    login_as(:admin_user)
    Factory(:root_page)
    Factory(:naringslivsgruppen_tag)
    news_post = Factory(:nlg_news_post)
    
    visit "/"
    within "div#post_#{news_post.id}" do
      click_link "Redigera"
    end
    
    fill_in "Name", :with => "Updated news"
    click "Spara Post"
    
    current_path.should == "/"
    
    # TODO page.should have_success_message
    page.should have_content("Updated news")
  end
  
  scenario "viewing news with tag" do
    Factory(:root_page)
    Factory(:naringslivsgruppen_tag)
    Factory(:nlg_news_post)
    visit "/?tags=NLG"
    
    page.should have_content("Näringslivsgruppsnyhet")
  end
end