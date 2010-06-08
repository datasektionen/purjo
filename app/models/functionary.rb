class Functionary < ActiveRecord::Base
  belongs_to :chapter_post
  belongs_to :person

  def person_or_postponed
    if postponed
      return "<em>Bordlagd</em>"
    end
    person
  end 
end
