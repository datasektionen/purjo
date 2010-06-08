class CreateChapterPosts < ActiveRecord::Migration
  def self.up
    create_table :chapter_posts do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :chapter_posts
  end
end
