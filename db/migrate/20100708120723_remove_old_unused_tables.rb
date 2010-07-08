class RemoveOldUnusedTables < ActiveRecord::Migration
  def self.up
    drop_table :events
    drop_table :comments
    drop_table :groups
    
    drop_table :list_fields
    drop_table :list_field_entries
    drop_table :list_permissions
    drop_table :lists
    drop_table :node_permissions
  end

  def self.down
  end
end
