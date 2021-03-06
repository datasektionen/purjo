require File.dirname(__FILE__) + '/acceptance_helper'

feature "page management" do
  include Authentication
  
  include Rails.application.routes.url_helpers
  background do
    @root_page = Factory(:root_page)
    mock_roles
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
    click "Skapa Text node"
    
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
    
    click "Spara Text node"
    
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
  
  scenario "removing a page from the tree view" do
    login_as(:admin_user)
    about = Factory(:about_page)
    root = TextNode.find_by_url("/")
    visit text_node_children_path(root)
    
    within("#text_node_#{about.id}") do
      click "Ta bort sida"
    end
    
    page.should have_content(%Q{Är du säker på att du vill ta bort denna sida})
    page.should have_content(%Q{Om datasektionen})
    
    click "Ja"
    
    current_path.should == '/'
    visit text_node_children_path(root)
    page.should_not have_content("Om datasektionen")
  end
  
  
end
