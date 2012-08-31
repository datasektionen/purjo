class KillVersioning < ActiveRecord::Migration
  def self.up
    drop_table :changes
  end

  def self.down
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
