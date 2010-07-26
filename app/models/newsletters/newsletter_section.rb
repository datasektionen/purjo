class NewsletterSection < ActiveRecord::Base
  belongs_to :newsletter

  default_scope :order => 'newsletter_id DESC, `order` ASC, created_at ASC'
  
  validates_presence_of :title, :body
end
