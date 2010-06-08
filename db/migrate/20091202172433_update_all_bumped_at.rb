class UpdateAllBumpedAt < ActiveRecord::Migration
  def self.up
    Post.all.each do |post|
        post.bumped_at = post.created_at
        post.save!
    end
  end

  def self.down
    Post.update_all ["bumped_at = ?", nil] 
  end
end
