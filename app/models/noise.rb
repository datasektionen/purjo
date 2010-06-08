class Noise < ActiveRecord::Base
	belongs_to :post
	belongs_to :person

  def editable?
    ((Time.now-created_at < 10.minutes) and (Person.current.id == person_id)) or Person.current.editor?
  end
end
