class CreateTravelYears < ActiveRecord::Migration
  def self.up
    create_table :travel_years do |t|
      t.integer :year
      t.string :layout

      t.timestamps
    end
  end

  def self.down
    drop_table :travel_years
  end
end
