class AddMySettingsToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :serialized_my_settings, :text
  end

  def self.down
    remove_column :people, :serialized_my_settings
  end
end
