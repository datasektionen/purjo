class NewsletterSection < ActiveRecord::Base
  belongs_to :newsletter
  
  validates_presence_of :title, :body
end
