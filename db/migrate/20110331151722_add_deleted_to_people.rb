class AddDeletedToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :deleted, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :people, :deleted
  end
end
