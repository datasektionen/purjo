class RemoveMySettingsFromPeople < ActiveRecord::Migration
  def self.up
    remove_column :people, :serialized_my_settings
  end

  def self.down
  end
end
