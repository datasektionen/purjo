class DeliveryBase
  
  include ActiveModel::Validations
  include ActiveModel::Conversion  
  extend ActiveModel::Naming
  
  attr_reader :template, :list
  
  def initialize(newsletter, attributes = {})  
    @newsletter = newsletter
    
    attributes.each do |name, value|  
      send("#{name}=", value)  
    end
    
    fetch_template
    fetch_list
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