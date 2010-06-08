class MergeFirstNameAndLastName < ActiveRecord::Migration
  def self.up
    add_column :students, :name, :string
    remove_column :students, :first_name
    remove_column :students, :last_name
  end

  def self.down
    remove_column :students, :name
    add_column :students, :first_name, :string
    add_column :students, :last_name, :string
  end
end
