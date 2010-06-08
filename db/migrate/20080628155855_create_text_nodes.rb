class CreateTextNodes < ActiveRecord::Migration
  def self.up
    create_table :text_nodes do |t|
      t.integer :parent_id
      t.string :name
      t.string :url
      t.text :contents
      
      t.timestamps
    end
    
    TextNode.create_versioned_table
  end

  def self.down
    drop_table :text_nodes
    TextNode.drop_versioned_table
  end
end
