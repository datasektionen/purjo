class FixListMigrations < ActiveRecord::Migration
  def self.up
    add_column :list_field_entries, :list_field_id, :integer
    add_column :list_entries, :list_id, :integer
  end

  def self.down
    remove_column :list_entries, :list_id
    remove_column :list_field_entries, :list_field_id
  end
end
