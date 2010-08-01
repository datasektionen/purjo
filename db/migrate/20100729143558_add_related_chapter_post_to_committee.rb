class AddRelatedChapterPostToCommittee < ActiveRecord::Migration
  def self.up
    change_table :committees do |t|
      t.references :chapter_post
    end
  end

  def self.down
    remove_column :committees, :chapter_post_id
  end
end
