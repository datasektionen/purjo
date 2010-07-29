class CreateCommittees < ActiveRecord::Migration
  def self.up
    create_table :committees do |t|
      t.string :name
      t.text :description
      t.timestamps
      t.string :slug
    end
  end

  def self.down
    drop_table :committees
  end
end
