class FixEventTimeOffsets < ActiveRecord::Migration
  def self.up
     Event.connection.execute("UPDATE events SET " +
       "starts_at = starts_at - INTERVAL 1 hour, " +
       "ends_at = ends_at - INTERVAL 1 hour")
  end

  def self.down
     Event.connection.execute("UPDATE events SET " +
       "starts_at = starts_at + INTERVAL 1 hour, " +
       "ends_at = ends_at + INTERVAL 1 hour")
  end
end
