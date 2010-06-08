class CreateFileNodes < ActiveRecord::Migration
  def self.up
    create_table :file_nodes do |t|
      t.integer 'parent_id'
      t.integer 'size'
      t.string 'content_type'
      t.string 'filename'
      t.string 'url'
      
      t.timestamps
    end
  end

  def self.down
    drop_table :file_nodes
  end
end
