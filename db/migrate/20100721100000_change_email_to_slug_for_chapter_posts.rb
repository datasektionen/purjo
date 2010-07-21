class ChangeEmailToSlugForChapterPosts < ActiveRecord::Migration
  def self.up
    rename_column :chapter_posts, :email, :slug
    execute "UPDATE chapter_posts SET slug = REPLACE(slug, '@d.kth.se', '')"
  end

  def self.down
    rename_column :chapter_posts, :slug, :email
    execute "UPDATE chapter_posts SET email = CONCAT(email, '@d.kth.se')"
  end
end
