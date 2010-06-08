class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string 'title'
      t.text 'text'
      t.boolean 'news'
      t.boolean 'calendar'
      t.datetime 'start_date'
      t.datetime 'end_date'
      t.datetime 'expires_at'
      t.boolean 'show_time'
      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end
