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
  
  scenario "viewing file list without files" do
    Factory(:about_page)
    login_as(:admin_user)
    
    visit("/om_datasektionen")
    click_admin_link "Lista filer"
    
    page.should have_content("Inga filer uppladdade")
  end
  
  scenario "Uploading a file" do
    Factory(:about_page)
    login_as(:admin_user)
    
    visit("/om_datasektionen")
    
    save_and_open_page
    
    click_admin_link "Ny fil"
    
    attach_file("Fil", Rails.root + "spec/fixtures/protokoll.pdf")
    
    click "Skapa File node"
    
    #page.should have_success_message
    
    current_path.should == "/om_datasektionen"
    
    click_admin_link "Lista filer"
    
    page.should have_content("/om_datasektionen/protokoll.pdf")
  end
end
