class CreateElectionEvents < ActiveRecord::Migration
  def self.up
    create_table :election_events do |t|
      t.string :name
      t.date :date

      t.timestamps
    end
  end

  def self.down
    drop_table :election_events
  end
end
