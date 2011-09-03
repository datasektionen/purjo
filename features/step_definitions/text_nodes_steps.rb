def root_node
  TextNode.find_by_url("/")
end

Given /a root node/ do
  root_node.should_not be_nil
end

Given /^a text node with name "(.*)" and content "(.*)"$/ do |name, content|
  t = TextNode.create!(:name => name, :contents => content, :parent => root_node)
end

When /^I visit "(.*)"$/ do |url|
  visit url
end

When /^I create a new text node with content "(.*)" and name "(.*)"$/ do |content, name|
  visit new_text_node_child_path(root_node)
  fill_in "text_node_name", :with => name
  fill_in "text_node_contents", :with => content
  click_button "Spara"
end

When /^I change the name of node with url "(.*)" to "(.*)"$/ do |url, name|
  visit url

  click_link "Redigera sida"

  fill_in "text_node_name", :with => name
  click_button "Spara"
end

When /^I press the delete button on the node with url "(.*)"$/ do |url|
  visit url
  click_link "Ta bort sida"
end

When /^I create a new text node with name "(.*)" and content "(.*)" and custom layout "(.*)"$/ do |name, content, layout|
  visit new_text_node_child_path(root_node)
  fill_in "text_node_name", :with => name
  fill_in "text_node_contents", :with => content
  fill_in "text_node_custom_layout", :with => layout
  click_button "Spara"
end

Then /I want to debug/ do
  debugger
end
