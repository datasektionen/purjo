class AddPersonalInfoToPerson < ActiveRecord::Migration
  def self.up
    add_column :people, :address, :string
    add_column :people, :phone, :string
    add_column :people, :homepage, :string
    add_column :people, :nickname, :string
    add_column :people, :startyear, :integer
  end

  def self.down
    remove_column :people, :startyear
    remove_column :people, :nickname
    remove_column :people, :homepage
    remove_column :people, :phone
    remove_column :people, :address
  end
end
