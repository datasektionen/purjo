class TestDelivery < DeliveryBase
  attr_accessor :email
  validates_presence_of :email
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i
  
  def perform
    return false unless valid?
    if update_newsletter(@newsletter)
      hominid.send_test(@newsletter.campaign_id, [email])
    end
  end
end