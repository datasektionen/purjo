class AddEmailToChapterPost < ActiveRecord::Migration
  def self.up
    add_column :chapter_posts, :email, :string
  end

  def self.down
    remove_colum :chapter_posts, :email
  end
end
