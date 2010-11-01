class ParanoidDeleteTextNodes < ActiveRecord::Migration
  def self.up
    change_table :text_nodes do |t|
      t.datetime :deleted_at
      t.boolean :deleted, :default => false
    end
  end

  def self.down
    change_table :text_nodes do |t|
      t.remove :deleted_at
      t.remove :deleted
    end
  end
end
