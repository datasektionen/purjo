class AddHasChosenSettingsToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :has_chosen_settings, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :people, :has_chosen_settings
  end
end
