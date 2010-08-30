class CreateMenuItems < ActiveRecord::Migration
  def self.up
    create_table :menu_items do |t|
      t.integer :parent_id
      t.integer :text_node_id
      t.string :title
      t.integer :sort_order

      t.timestamps
    end
  end

  def self.down
    drop_table :menu_items
  end
end
