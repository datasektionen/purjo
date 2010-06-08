class CreateListEntries < ActiveRecord::Migration
  def self.up
    create_table :list_entries do |t|
      t.integer :person_id
      t.text :comment

      t.timestamps
    end
  end

  def self.down
    drop_table :list_entries
  end
end
