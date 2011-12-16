class AddSubscribeToCommentsToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :subscribe_to_comments, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :people, :subscribe_to_comments
  end
end
