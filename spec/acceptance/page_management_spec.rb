require File.dirname(__FILE__) + '/acceptance_helper'

feature "page management" do
  include Authentication
  
  include Rails.application.routes.url_helpers
  background do
    @root_page = Factory(:root_page)
    Factory(:admin_role)
    Factory(:editor_role)
    
    Person.class_eval do
      Role.all.each do |role|
        define_method "#{role.to_s}?" do 
          has_role?(role.to_s)
        end
      end
    end
  end
  
  scenario "show the root page" do
    Factory(:start_page)
    visit("/")
    page.should have_content("This is the start node")
  end
  
  scenario "creating a new page" do
    login_as(:admin_user)
    
    visit(all_nodes_path)
    selector = "li#text_node_#{@root_page.id}"

    within(selector) do
      click_link "Ny undersida"
    end
    
    fill_in "Name", :with => "Page title"
    fill_in "Contents", :with => "Random text"
    click "Create Text node"
    
    current_path.should == '/page_title'
    
    visit(all_nodes_path)
    page.should have_content("Page title")
  end
  
  scenario "editing a page" do
    login_as(:admin_user)
    Factory(:about_page)
        
    visit "/om_datasektionen"
    
    click_admin_link "Redigera sida"
    
    fill_in "Contents", :with => 'Uppdaterad information om datasektionen'
    
    click "Update Text node"
    
    visit "/om_datasektionen"
    
    page.should have_content("Uppdaterad information om datasektionen")
  end
  
  scenario "removing a page" do
    login_as(:admin_user)
    Factory(:about_page)
    visit "/om_datasektionen"
    click_admin_link "Ta bort sida"
    
    # TODO  it should have
    #page.should have_success_message
    
    visit all_nodes_path
    
    page.should_not have_content("Om datasektionen")
  end
  
  RSpec::Matchers.define :have_success_message do
    match do |page|
      page.should have_css("div#flash_notice")
    end
    
    failure_message_for_should do |actual|
      "expected that the page should contain a success message, but it didn't"
    end

    failure_message_for_should_not do |actual|
      "expected that the page should not contain a sucess message, but it did"
    end
  end
  
  
end
