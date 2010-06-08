class AddShowInListToListFields < ActiveRecord::Migration
  def self.up
    add_column :list_fields, :show_in_list, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :list_fields, :show_in_list
  end
end
