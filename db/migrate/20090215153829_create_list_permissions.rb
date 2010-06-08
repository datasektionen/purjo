class CreateListPermissions < ActiveRecord::Migration
  def self.up
    create_table :list_permissions do |t|
      t.integer :list_id
      t.integer :person_id

      t.timestamps
    end
  end

  def self.down
    drop_table :list_permissions
  end
end
