class Nominee < ActiveRecord::Base
  belongs_to :person
  belongs_to :chapter_post
  belongs_to :election_event
  
  scope :ordered, order("IF(status=0,1.5,status)")
  scope :for, lambda {|chapter_post| where(:chapter_post_id => chapter_post.id)}

  validates_presence_of :person_id

  attr_accessor :username
  def username
    person.nil? ? "" : person.kth_username
  end

  def status_text
    return "Tackat ja" if status == 1
    return "Tackat nej" if status == 2
    "Ej svar"
  end
  
end
