class AddTravelYearIdToCvs < ActiveRecord::Migration
  def self.up
    add_column :cvs, :travel_year_id, :integer
  end

  def self.down
    remove_column :cvs, :travel_year_id
  end
end
