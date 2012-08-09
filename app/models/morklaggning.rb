class Morklaggning < ActiveRecord::Base
  belongs_to :person

  validate :person_id, :presence => true

  def username
    self.person.try :kth_username
  end

  # TODO: Revisit, refactor, fix!
  # This feels just plain wrong.
  def username=(val)
    self.person_id = Person.find_by_kth_username(val).id
  end
end
