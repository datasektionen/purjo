class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.string :name
      t.text :content
      
      # news_post stuffs
      t.boolean :news_post, :default => false
      t.datetime :expires_at

      # calendar_post stuffs
      t.boolean :calendar_post, :default => false
      t.datetime :starts_at
      t.datetime :ends_at
      t.boolean :all_day

      t.integer :created_by_id

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
