class AddAdditionalContentToTextNode < ActiveRecord::Migration
  def self.up
    add_column :text_nodes, :additional_content, :text, :default => '', :null => false
  end

  def self.down
    remove_column :text_nodes, :additional_content
  end
end
