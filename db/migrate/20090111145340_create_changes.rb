class CreateChanges < ActiveRecord::Migration
  def self.up
    create_table :changes do |t|
      t.string :action
      t.integer :changed_object_id
      t.string :changed_object_type
      t.integer :changed_by_id

      t.timestamps
    end
  end

  def self.down
    drop_table :changes
  end
end
