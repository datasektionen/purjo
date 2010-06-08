class AddDoneToCvs < ActiveRecord::Migration
  def self.up
    add_column :cvs, :done, :boolean
  end

  def self.down
    remove_column :cvs, :done
  end
end
