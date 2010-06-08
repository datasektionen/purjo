class AddCourseHomePageToCourse < ActiveRecord::Migration
  def self.up
    add_column :courses, :course_home_page, :string
  end

  def self.down
    remove_column :courses, :course_home_page
  end
end
