module HominidHelpers
  ListName = "Datasektionen Allmänt"
  ListId = "deadbeef"
  TemplateName = "Datasektionen Template"
  TemplateId = 4711
  SubscriberCount = 110
  ApiKey = "abc123"
  
  def mock_hominid
    hominid = Hominid::Base.new(:api_key => "123-us1")
    mock_hominid_templates(hominid)
    mock_hominid_lists(hominid)
    mock_hominid_create_campaign(hominid)
    mock_hominid_send_test(hominid)
    mock_hominid_send(hominid)
    mock_hominid_update(hominid)
    hominid
  end
  
  def mock_hominid_templates(hominid)
    hominid.stub(:templates).and_return([
      {
        "name" => TemplateName, 
        "layout" => "Basic", 
        "preview_image" => "http://gallery.mailchimp.com/7afea83f41772e96ae2421882/template-screens/160837_screen.2.png", 
        "sections" => [
          "header", 
          "main", 
          "footer"
        ], 
        "id" => TemplateId.to_f           # Hominid gives floats for some reason...
      }, 
      {
        "name" => "test", 
        "layout" => "", 
        "preview_image" => "", 
        "sections" => [
          "header", 
          "content", 
          "footer"
        ], 
        "id" => (TemplateId + 10).to_f   # See above
      }
    ])
  end
  
  def mock_hominid_lists(hominid)
    dsekt_list = {
      "cleaned_count_since_send" => 0.0, 
      "unsubscribe_count_since_send" => 0.0, 
      "name" => ListName, 
      "member_count_since_send" => 1.0, 
      "default_language" => "en", 
      "default_from_name" => "Datasektionen", 
      "email_type_option" => false, 
      "member_count" => SubscriberCount,
      "unsubscribe_count" => 0.0, 
      "id" => ListId, 
      "cleaned_count" => 0.0, 
      "web_id" => 706685, 
      "default_subject" => "", 
      "default_from_email" => "patrik.stenmark+dsekt@gmail.com", 
      "list_rating" => 0.0, 
      "date_created" => "2010-05-19 07:55:42"
    }
    hominid.stub(:find_list_by_id).with(ListId).and_return(dsekt_list)
    
    ior_list = {
      "cleaned_count_since_send" => 0.0,
      "unsubscribe_count_since_send" => 0.0,
      "name" => "Ior",
      "member_count_since_send" => 0.0,
      "default_language" => "en",
      "default_from_name" => "Datasektionens Informationsorgan",
      "email_type_option" => false,
      "member_count" => 1.0,
      "unsubscribe_count" => 0.0,
      "id" => "1f3c1d4b9d",
      "cleaned_count" => 0.0,
      "web_id" => 757525,
      "default_subject" => "",
      "default_from_email" => "patrik.stenmark@gmail.com",
      "list_rating" => 0.0,
      "date_created" => "2010-06-06 16:24:45"
    }
    hominid.stub(:find_list_by_id).with('1f3c1d4b9d').and_return(ior_list)
    
    hominid.stub(:lists).and_return([
      dsekt_list,
      ior_list
    ])
  end
  
  def mock_hominid_create_campaign(hominid)
    hominid.stub(:create_campaign).and_return("deadbeef")
  end
  
  def mock_hominid_update(hominid)
    hominid.stub(:update).and_return(true)
  end
  
  def mock_hominid_send_test(hominid)
    hominid.stub(:send_test).and_return(true)
  end
  
  def mock_hominid_update(hominid)
    hominid.stub(:update).and_return(true)
  end
  
  def mock_hominid_send(hominid)
    hominid.stub(:send).and_return(true)
  end
end

Rspec.configure do |config|
  config.include HominidHelpers
end
