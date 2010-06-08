ApplicationController.prepend_view_path(File.join(Rails.root, "spec", "fixtures"))

def root_node
  TextNode.find_by_url("/")
end

Given /a root node/ do
  TextNode.create!(:name => 'root', :contents => 'Root!')
end

Given /^a text node with name "(.*)" and content "(.*)"$/ do |name, content|
  t = TextNode.create!(:name => name, :contents => content, :parent => root_node)
end

When /^I visit "(.*)"$/ do |url|
  visit url
end

When /^I create a new text node with content "(.*)" and name "(.*)"$/ do |content, name|
  visit new_text_node_child_path(root_node)
  fill_in "Name", :with => name
  fill_in "Contents", :with => content
  click_button "Spara"
end

When /^I change the name of node with url "(.*)" to "(.*)"$/ do |url, name|
  visit url
  
  click_link "edit_page_button"
  
  fill_in "Name", :with => name
  click_button "Spara"
end


When /^I press the delete button on the node with url "(.*)"$/ do |url|
  click_link "delete_page_button"
end

When /^I create a new text node with name "(.*)" and content "(.*)" and custom layout "(.*)"$/ do |name, content, layout|
  visit new_text_node_child_path(root_node)
  fill_in "Name", :with => name
  fill_in "Contents", :with => content
  fill_in "Custom layout", :with => layout
  click_button "Spara"
end
