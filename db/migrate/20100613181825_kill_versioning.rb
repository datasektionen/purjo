class KillVersioning < ActiveRecord::Migration
  def self.up
    drop_table :changes
    drop_table :text_node_versions
  end

  def self.down
    create_table "text_node_versions", :force => true do |t|
      t.integer  "text_node_id"
      t.integer  "version"
      t.integer  "parent_id"
      t.string   "name"
      t.string   "url"
      t.text     "contents"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "custom_layout"
    end
    
    create_table "changes", :force => true do |t|
      t.string   "action"
      t.integer  "changed_object_id"
      t.string   "changed_object_type"
      t.integer  "changed_by_id"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
    
  end
end
