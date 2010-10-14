class RenameSentToPublishedInNewsletter < ActiveRecord::Migration
  def self.up
    change_table :newsletters do |t|
      t.rename :sent, :published
    end
  end

  def self.down
    change_table :newsletters do |t|
      t.rename :published, :sent
    end
  end
end
