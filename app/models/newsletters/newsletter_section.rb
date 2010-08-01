class NewsletterSection < ActiveRecord::Base
  belongs_to :newsletter

  scope :sorted, order(:newsletter_id.desc, :order.asc, :created_at.asc)
  
  validates_presence_of :title, :body
end
