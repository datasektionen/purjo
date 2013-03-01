class AddPublishedAtToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :published_at, :datetime

    Post.unscoped.all.each do |p|
      p.published_at = p.created_at
      p.save
    end
  end

  def self.down
    remove_column :posts, :published_at
  end
end
