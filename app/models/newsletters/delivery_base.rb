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
    
  private
  
  
end