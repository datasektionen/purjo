class MakeMorklaggningsMakeSense < ActiveRecord::Migration
  def self.up
    change_table :morklaggnings do |t|
      t.remove :username
      t.integer :person_id
    end
  end

  def self.down
    change_table :morklaggnings do |t|
    end
  end
end
