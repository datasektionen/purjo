class CreateNominees < ActiveRecord::Migration
  def self.up
    create_table :nominees do |t|
      t.integer :person_id
      t.integer :election_event_id
      t.integer :chapter_post_id
      t.integer :status

      t.timestamps
    end
  end

  def self.down
    drop_table :nominees
  end
end
