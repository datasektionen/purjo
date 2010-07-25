class DeliveryBase
  include ActiveModel::Validations
  include ActiveModel::Conversion  
  extend ActiveModel::Naming
  include Ior::Hominid::Common
  
  def initialize(newsletter, attributes = {})  
    @newsletter = newsletter
    
    attributes.each do |name, value|  
      send("#{name}=", value)  
    end
    
    fetch_template
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
  
  def all_lists
    hominid.lists
  end
  
  def update_newsletter(newsletter)
    html_result = hominid.update(newsletter.campaign_id, 'content', {'html_CONTENT' => newsletter.formatted_content})
    text_result = hominid.update(newsletter.campaign_id, 'content', {'text' => newsletter.text_content})
    
    html_result && text_result
  end
  
  private
  
  
end