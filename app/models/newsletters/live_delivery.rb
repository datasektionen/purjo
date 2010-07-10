class LiveDelivery < DeliveryBase
  def perform
    if hominid.update(@newsletter.campaign_id, 'content', {'html_CONTENT' => @newsletter.formatted_content})
      if hominid.send(@newsletter.campaign_id)
        @newsletter.sent!
      else
        @newsletter.fail!
      end
    end
  end
end