class CreateListFields < ActiveRecord::Migration
  def self.up
    create_table :list_fields do |t|
      t.string :name
      t.string :description
      t.string :kind
      t.string :value
      t.integer :position
      
      t.integer :list_id

      t.timestamps
    end
  end

  def self.down
    drop_table :list_fields
  end
end
