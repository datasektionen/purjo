class AddTextToListFieldEntries < ActiveRecord::Migration
  def self.up
    add_column :list_field_entries, :text, :text
  end

  def self.down
    remove_column :list_field_entries, :text
  end
end
