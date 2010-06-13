class PaperclippifyFileNodes < ActiveRecord::Migration
  def self.up
    change_table :file_nodes do |t|
      t.rename :filename, :resource_file_name
      t.rename :content_type, :resource_content_type
      t.integer :resource_file_size
      t.datetime :resource_updated_at
    end
  end

  def self.down
    change_table :file_nodes do |t|
    end
  end
end
