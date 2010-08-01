Factory.define(:text_node) do
  
end

Factory.define(:root_page, :parent => :text_node) do |f|
  f.url '/'
  f.name 'Root'
  f.contents "This is the root"
end

Factory.define(:start_page, :parent => :text_node) do |f|
  f.name 'Start'
  f.contents "This is the start node"
  f.parent { TextNode.find_by_url("/") || Factory(:root_page) }
end

Factory.define(:welcome_page, :parent => :text_node) do |f|
  f.name 'Welcome'
  f.contents "This is the Welcome node"
  f.parent { TextNode.find_by_url("/") || Factory(:root_page) }
end

Factory.define(:about_page, :parent => :text_node) do |f|
  f.name "Om datasektionen"
  f.contents "Den här sidan handlar om datasektionen"
  f.parent { TextNode.find_by_url("/") || Factory(:root_page) }
end

Factory.define(:file_node) do
  
end

Factory.define(:protocol_file, :parent => :file_node) do |f|
  include ActionDispatch::TestProcess
  f.resource   { fixture_file_upload( Rails.root + 'spec/fixtures/protokoll.pdf') }
  f.parent { TextNode.find_by_url("/") || Factory(:root_page) }
end

Factory.define(:person) do |f|
  
end

Factory.define(:admin_user, :parent => :person) do |f|
  f.kth_ugid 'u1something'
  f.kth_username 'admin'
  f.first_name "Admin"
  f.last_name "Bofh"
  f.email "bofh@example.com"
  f.after_create do |p|
    p.roles << (Role.find_by_name("admin") || Factory(:admin_role))
    p.save!
  end
end

Factory.define(:norbert_nollan, :parent => :person) do |f|
  f.kth_ugid 'u1n0rb3rt'
  f.kth_username 'norbert'
  f.first_name "Norbert"
  f.last_name "nØllan"
  f.email "norbert@example.com"
end

Factory.define(:ture_teknolog, :parent => :person) do |f|
  f.kth_ugid 'u1turetek'
  f.kth_username 'turetek'
  f.first_name "Ture"
  f.last_name "Teknolog"
  f.email "ture.teknolog@example.com"
  f.has_chosen_settings true
  
  f.after_create do |p|
    p.roles << (Role.find_by_name("editor") || Factory(:editor_role))
    p.save!
  end
  
end


Factory.define(:admin_role, :class => 'Role') do |r|
  r.name "admin"
end

Factory.define(:editor_role, :class => 'Role') do |r|
  r.name "editor"
end

Factory.define(:tentapub_calendar_post, :class => 'Post') do |f|
  f.name "Tentapub"
  f.content "DKM anordnar tentapub"
  f.calendar_post true
  f.starts_at 10.days.from_now.at_midnight + 18.hours
  f.ends_at 11.days.from_now.at_midnight + 3.hours
end

Factory.define(:nlg_news_post, :class => 'Post') do |f|
  f.name "Näringslivsgruppsnyhet"
  f.news_post true
  f.content "fuckoff"
  f.after_create do |post|
    post.created_by = Person.find_by_kth_username("admin") || Factory(:admin_user)
    nlg_tag = ActsAsTaggableOn::Tag.find_by_name('NLG') || Factory(:naringslivsgruppen_tag)
    post.taggings.create!(:context => 'categories', :tag => nlg_tag)
    post.save!
  end
end

Factory.define(:naringslivsgruppen_tag, :class => 'ActsAsTaggableOn::Tag') do |f|
  f.name "NLG"
end

Factory.define(:newsletter) do |f|
  f.subject "Nyhetsbrevet"
end

Factory.define(:newsletter_march_2010, :parent => :newsletter) do |f|
  f.subject "Mars 2010"
end
