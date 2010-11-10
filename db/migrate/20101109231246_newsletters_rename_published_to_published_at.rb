class NewslettersRenamePublishedToPublishedAt < ActiveRecord::Migration
  def self.up
    rename_column :newsletters, :published, :published_at
  end

  def self.down
    rename_column :newsletters, :published_at, :published
  end
end
