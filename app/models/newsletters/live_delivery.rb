class LiveDelivery < DeliveryBase
  def perform
    if hominid.update(@newsletter.campaign_id, 'content', {'html_CONTENT' => @newsletter.formatted_content})
      hominid.send(@newsletter.campaign_id)
    end
  end
end