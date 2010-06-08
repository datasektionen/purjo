class AddCustomLayoutToTextNode < ActiveRecord::Migration
  def self.up
    add_column :text_nodes, :custom_layout, :string
    add_column :text_node_versions, :custom_layout, :string
  end

  def self.down
    remove_column :text_nodes, :custom_layout
    remove_column :text_node_versions, :custom_layout
  end
end
