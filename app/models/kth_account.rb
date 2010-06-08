class KthAccount < ActiveRecord::Base
  belongs_to :person
  
  validates_presence_of :person_id
  validates_associated :person
end
