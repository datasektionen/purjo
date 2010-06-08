class ExtendStudentWithThsData < ActiveRecord::Migration
  def self.up
    remove_column :students, :xfinger
    remove_column :students, :phone
    add_column :students, :homedir, :string
    add_column :students, :gender, :string
    add_column :students, :phone_home, :string
    add_column :students, :phone_mobile, :string
  end

  def self.down
    add_column :students, :xfinger
    add_column :students, :phone
    remove_column :students, :homedir
    remove_column :students, :gender
    remove_column :students, :phone_home
    remove_column :students, :phone_mobile
  end
end
