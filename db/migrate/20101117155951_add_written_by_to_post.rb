class AddWrittenByToPost < ActiveRecord::Migration
  def self.up
    change_table :posts do |t|
      t.integer :written_by_id
    end
  end

  def self.down
    change_table :posts do |t|
      t.remove :written_by_id
    end
  end
end
