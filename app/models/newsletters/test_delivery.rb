class TestDelivery < DeliveryBase
  attr_accessor :email
  validates_presence_of :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  
  def perform
    hominid.update(@newsletter.campaign_id, 'content', {'html_CONTENT' => @newsletter.formatted_content})
    hominid.send_test(@newsletter.campaign_id, [email])
  end
end