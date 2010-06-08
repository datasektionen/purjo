class CreateFunctionaries < ActiveRecord::Migration
  def self.up
    create_table :functionaries do |t|
      t.integer :person_id
      t.integer :chapter_post_id
      t.date :active_from
      t.date :active_to
      t.boolean :postponed

      t.timestamps
    end
  end

  def self.down
    drop_table :functionaries
  end
end
