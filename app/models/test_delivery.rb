class TestDelivery
  include ActiveModel::Validations
  include ActiveModel::Conversion  
  extend ActiveModel::Naming
  
  attr_accessor :email
  attr_reader :template, :list
  validates_presence_of :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  
  def initialize(newsletter, attributes = {})  
    @newsletter = newsletter
    
    attributes.each do |name, value|  
      send("#{name}=", value)  
    end
    
    fetch_template
    fetch_list
  end

  def perform
    hominid.update(@newsletter.campaign_id, 'content', {'html_CONTENT' => @newsletter.formatted_content})
    hominid.send_test(@newsletter.campaign_id, [email])
  end
  
  def persisted?
    false
  end
  
  def template_name
    template['name']
  end
  
  def template_id
    template['id']
  end
  
  def subscriber_count
    list['member_count']
  end
  
  def list_name
    list['name']
  end
  
  def list_id
    list['id']
  end
  
  private
  
  def fetch_template
    @template = hominid.templates.detect { |template| template['id'] == Purjo2::Application.settings[:newsletter_template_id]  }
  end
  
  def fetch_list
    @list = hominid.find_list_by_id(Purjo2::Application.settings[:newsletter_list_id])
  end

  def hominid
    Hominid::Base.new(:api_key => Purjo2::Application.settings[:newsletter_api_key])
  end
end