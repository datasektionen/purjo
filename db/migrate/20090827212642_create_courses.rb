class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.string :name
      t.string :code
      t.float :hp
      t.string :level
      t.string :handbook_url

      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
