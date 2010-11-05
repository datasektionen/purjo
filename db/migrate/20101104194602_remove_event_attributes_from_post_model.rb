class RemoveEventAttributesFromPostModel < ActiveRecord::Migration
  def self.up
=begin
    change_table :posts do |t|
      t.remove :news_post
      t.remove :calendar_post
      t.remove :starts_at
      t.remove :ends_at
      t.remove :all_day
    end
=end
  end

  def self.down
=begin
    change_table :posts do |t|
      t.boolean  "news_post",     :default => false
      t.boolean  "calendar_post", :default => false
      t.datetime "starts_at"
      t.datetime "ends_at"
      t.boolean  "all_day"
    end
=end
  end
end
