class LiveDelivery < DeliveryBase
  attr_accessor :list_id
  
  validates_presence_of :list_id
  
  def perform
    return false unless valid?
    
    if hominid.update(@newsletter.campaign_id, 'content', {'html_CONTENT' => @newsletter.formatted_content})
      if hominid.send(@newsletter.campaign_id)
        @newsletter.sent!
      else
        @newsletter.fail!
      end
    end
  end
  
  def subscriber_count
    list['member_count']
  end
  
  def list_name
    list['name']
  end
  
  def list
    @list || fetch_list
  end
  
  private
  def fetch_list
    @list = hominid.find_list_by_id(list_id)
  end
  
  
end