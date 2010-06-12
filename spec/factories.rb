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

Factory.define(:about_page, :parent => :text_node) do |f|
  f.name "Om datasektionen"
  f.contents "Den här sidan handlar om datasektionen"
  f.parent { TextNode.find_by_url("/") || Factory(:root_page) }
end

Factory.define(:person) do |f|
  
end

Factory.define(:admin_user, :parent => :person) do |f|
  f.kth_ugid 'u1something'
  f.kth_username 'mradmin'
  f.first_name "Admin"
  f.last_name "Bofh"
  f.email "bofh@example.com"
  f.after_create do |p|
    p.roles << (Role.find_by_name("admin") || Factory(:admin_role))
    p.save!
  end
end

Factory.define(:admin_role, :class => 'Role') do |r|
  r.name "admin"
end

Factory.define(:editor_role, :class => 'Role') do |r|
  r.name "editor"
end
