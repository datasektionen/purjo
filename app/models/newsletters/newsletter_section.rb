class NewsletterSection < ActiveRecord::Base
  belongs_to :newsletter

  default_scope :order => "newsletter_sections.newsletter_id desc, newsletter_sections.order asc, newsletter_sections.created_at asc"
  
  validates_presence_of :title, :body
end
