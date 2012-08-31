class CreateTextNodes < ActiveRecord::Migration
  def self.up
    create_table :text_nodes do |t|
      t.integer :parent_id
      t.string :name
      t.string :url
      t.text :contents
      
      t.timestamps
    end
  end

  def self.down
    drop_table :text_nodes
  end
end
