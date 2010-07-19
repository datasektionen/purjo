class AddTitleToTextNodes < ActiveRecord::Migration
  def self.up
    add_column :text_nodes, :title, :string
  end

  def self.down
    remove_column :text_nodes, :title
  end
end
