class ImportEventsFromPosts < ActiveRecord::Migration
  class Post < ActiveRecord::Base
  end

  def self.up
    #raise "Post is missing the required attributes!" unless Post.respond_to?(:calendar_posts)
    Post.where(:calendar_post => true).each do |p|
      e = Event.new({
        :name => p.name,
        :content => p.content,
        :starts_at => p.starts_at,
        :ends_at => p.ends_at,
        :all_day => p.all_day,
        :created_by_id => p.created_by_id,
        :created_at => p.created_at,
        :updated_at => p.updated_at
      })
      unless e.save
        raise "Event for post ##{p.id} could not be saved:\n" + e.errors.full_messages.join("\n")
      end
    end
  end

  def self.down
    Event.delete_all
    Event.connection.execute('ALTER TABLE events AUTO_INCREMENT = 0')
  end
end
