# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

root_page = TextNode.create!(name: 'root', url: '/', title: "root", contents: "I is root", additional_content: "")
TextNode.create(name: "Sektionen", url: "/sektionen", title: "Sektionen", contents: "")

person_info_file = Rails.root + "config/my_user.yml"
raise "Skapa en config/my_user.yml (exempel finns i katalogen)" unless File.exists?(person_info_file)

person_info = YAML::load(File.read(person_info_file))
person = Person.create!(person_info)

['editor', 'admin', 'pr'].each { |r| Role.create!(:name => r) }

person.roles << Role.find_by_name('admin')
person.save!

