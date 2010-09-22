class MakeMenuContainUrlInsteadOfNodeId < ActiveRecord::Migration
  def self.up
    add_column :menu_items, :url, :string
    remove_column :menu_items, :text_node_id
  end

  def self.down
  end
end
