require 'ior/hominid/common'
class Newsletter < ActiveRecord::Base
  scope :sorted, order('created_at desc')
  include Ior::Hominid::Common
  validates_presence_of :subject
  
  has_many :newsletter_sections
  
  before_validation :create_mailchimp_campaign, :on => :create
  
  state_machine :state, :initial => :pending do
    state :pending
    state :sent
    state :failed
    
    event :sent do
      transition :pending => :sent
    end
    
    event :fail do
      transition :pending => :failed
    end
  end
  
  # TODO textile i en modell? Tveksamt va?
  def formatted_content
    formatted_sections = newsletter_sections.map do |section|
      out = ""
      out << "<h2>#{section.title}</h2>\n"
      textilized = RedCloth.new(section.body)
      out + textilized.to_html
    end
    formatted_sections.join("\n")
  end
  
  def text_content
    newsletter_sections.map { |sec| sec.title + "\n" + ("-" * sec.title.length) + "\n\n" + sec.body }.join("\n\n\n")
  end
  
  private
  def create_mailchimp_campaign
    options = {
      :list_id => Purjo2::Application.settings[:newsletter_list_id],
      :template_id => Purjo2::Application.settings[:newsletter_template_id],
      :subject => self.subject,
      :from_email => Purjo2::Application.settings[:newsletter_from_email],
      :from_name => Purjo2::Application.settings[:newsletter_from_name],
      :to_email => Purjo2::Application.settings[:newsletter_to_email]
    }
    
    new_campaign_id = hominid.create_campaign(options)
    
    self.campaign_id = new_campaign_id
  end
end
