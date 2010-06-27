class Newsletter < ActiveRecord::Base
  validates_presence_of :name
  
  has_many :newsletter_sections
end
