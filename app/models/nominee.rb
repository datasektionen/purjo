class Nominee < ActiveRecord::Base
  belongs_to :person
  belongs_to :chapter_post
  belongs_to :election_event
  
  scope :ordered, order("IF(status=0,1.5,status)")

  validates_presence_of :person_id

  def status_text
    return "Tackat ja" if status == 1
    return "Tackat nej" if status == 2
    "Ej svar"
  end
  
end
