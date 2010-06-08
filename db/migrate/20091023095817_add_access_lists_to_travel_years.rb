class AddAccessListsToTravelYears < ActiveRecord::Migration
  def self.up
    add_column :travel_years, :serialized_project_members, :text
    add_column :travel_years, :serialized_company_users, :text
  end

  def self.down
    remove_column :travel_years, :serialized_company_users
    remove_column :travel_years, :serialized_project_members
  end
end
