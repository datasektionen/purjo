class AddOtherToCvs < ActiveRecord::Migration
  def self.up
    add_column :cvs, :other, :text
  end

  def self.down
    remove_column :cvs, :other
  end
end
