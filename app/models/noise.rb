# encoding: utf-8
class Noise < ActiveRecord::Base
	belongs_to :post
	belongs_to :person

  validates_length_of :message, :minimum => 2, :too_short => "Du måste ange ett meddelande"

  def editable?
    ((Time.now-created_at < 10.minutes) and (Person.current.id == person_id)) or Person.current.editor?
  end
end
