class ToPaperclipFromAttatchmentFuForCvs < ActiveRecord::Migration
  def self.up
    add_column :cvs, :photo_file_name,    :string
    add_column :cvs, :photo_content_type, :string
    add_column :cvs, :photo_file_size,    :integer
    add_column :cvs, :photo_updated_at,   :datetime

    remove_column :cvs, :size
    remove_column :cvs, :content_type
    remove_column :cvs, :filename
    remove_column :cvs, :height
    remove_column :cvs, :width
    remove_column :cvs, :parent_id
    remove_column :cvs, :thumbnail
  end

  def self.down
    remove_column :cvs, :photo_file_name,    :string
    remove_column :cvs, :photo_content_type, :string
    remove_column :cvs, :photo_file_size,    :integer
    remove_column :cvs, :photo_updated_at,   :datetime
    
    add_column :cvs, :size, :integer
    add_column :cvs, :content_type, :string
    add_column :cvs, :filename, :string
    add_column :cvs, :height, :integer
    add_column :cvs, :width, :integer
    add_column :cvs, :parent_id, :integer
    add_column :cvs, :thumbnail, :string
  end
end
