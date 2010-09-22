class Morklaggning < ActiveRecord::Base
  belongs_to :person

  def username
    self.person.try :kth_username
  end
  def username=(val)
    self.person = Person.find_by_kth_username(val)
  end
end
