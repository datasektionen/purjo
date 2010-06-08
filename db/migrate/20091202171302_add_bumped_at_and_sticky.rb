class AddBumpedAtAndSticky < ActiveRecord::Migration
  def self.up
    add_column :posts, :bumped_at, :datetime
    add_column :posts, :sticky, :boolean
  end

  def self.down
    remove_column :posts, :sticky
    remove_column :posts, :bumped_at
  end
end
