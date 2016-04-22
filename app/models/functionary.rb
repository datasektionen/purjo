class Functionary < ActiveRecord::Base
  belongs_to :chapter_post
  belongs_to :person
  
  scope :active, lambda { where(:active_to.gt => Time.now, :active_from.lt => Time.now) }
  scope :sorted, order(:active_from.desc)

  def person_or_postponed
    if postponed
      return "Vakantsatt"
    end
    person
  end 
end
