class RemoveBumpedAtFromPosts < ActiveRecord::Migration
  def self.up
    remove_column :posts, :bumped_at
  end

  def self.down
    add_column :posts, :bumped_at, :datetime
  end
end
