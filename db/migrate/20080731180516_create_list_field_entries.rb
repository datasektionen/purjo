class CreateListFieldEntries < ActiveRecord::Migration
  def self.up
    create_table :list_field_entries do |t|
      t.string :value
      t.integer :list_entry_id

      t.timestamps
    end
  end

  def self.down
    drop_table :list_field_entries
  end
end
