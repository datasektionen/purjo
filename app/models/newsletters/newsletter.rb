require 'ior/hominid/common'
class Newsletter < ActiveRecord::Base
  include Ior::Hominid::Common

  default_scope :order => "newsletters.created_at desc"
  scope :published, :order => "newsletters.published_at desc",
    :conditions => ["newsletters.published_at IS NOT NULL AND newsletters.published_at <= ?", Time.zone.now]

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

  attr_writer :draft
  def draft; @draft || published_at.blank?; end
  before_validation :clear_published_at_if_draft
  
  # TODO textile i en modell? Tveksamt va?
  def formatted_content
    sections = newsletter_sections

    toc = "<h2 id=\"toc\">Innehåll</h2>\n<ul>\n"
    sections.map do |section|
      toc << "<li><a href=\"#section-#{section.id}\">#{section.title}</a></li>\n"
    end
    toc << "</ul>\n"

    formatted_sections = sections.map do |section|
      out = ""
      out << "<h2 id=\"section-#{section.id}\">#{section.title}</h2>\n"
      out + RedCloth.new(section.body).to_html
    end

    toc + formatted_sections.join("\n\n")
  end
  
  def text_content
    sections = newsletter_sections

    toc = "Innehåll\n" + ("=" * 12)
    sections.map do |section|
      toc << "\n* #{section.title}"
    end

    sections_text = sections.map { |sec|
      sec.title + "\n" + ("=" * sec.title.length) + "\n\n" + sec.body
    }.join("\n\n\n")

    toc + "\n\n\n" + sections_text + "\n\n"
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

  def clear_published_at_if_draft
    self.published_at = nil if draft == 'true'
  end
end
