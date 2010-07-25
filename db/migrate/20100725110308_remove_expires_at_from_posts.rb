class RemoveExpiresAtFromPosts < ActiveRecord::Migration
  def self.up
    remove_column :posts, :expires_at
  end

  def self.down
    add_column :posts, :expires_at, :datetime
  end
end
