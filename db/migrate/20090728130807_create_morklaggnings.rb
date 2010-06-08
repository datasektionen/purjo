class CreateMorklaggnings < ActiveRecord::Migration
  def self.up
    create_table :morklaggnings do |t|
      t.string :username
      t.string :drifvarname

      t.timestamps
    end
  end

  def self.down
    drop_table :morklaggnings
  end
end
