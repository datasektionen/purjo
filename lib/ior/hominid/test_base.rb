module Ior
  module Hominid
    class TestBase
      ListName = "Datasektionen Allmänt"
      ListId = "deadbeef"
      TemplateName = "Datasektionen Template"
      TemplateId = 177701
      SubscriberCount = 110
      ApiKey = "abc123"
      
      def initialize(options)
        Rails.logger.debug("Hominid::TestBase.new called with options:")
        Rails.logger.debug(options.inspect)
      end
      
      def templates
        Rails.logger.debug("Hominid::TestBase#templates called")
        [
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
        ]
      end   

      def lists
        Rails.logger.debug("Hominid::TestBase#lists called")
        AllLists
      end
      
      def find_list_by_id(id)
        Rails.logger.debug("Hominid::TestBase#find_list_by_id called with #{id}")
        AllLists.find { |list| list['id'] == id }
      end
      
      def create_campaign(options)
        Rails.logger.debug("Hominid::TestBase#create_campaign called with options")
        Rails.logger.debug(options.inspect)
        
        "deadbeef"
      end
      
      def update(campaign_id, name, value)
        Rails.logger.debug("Hominid::TestBase#update called with #{campaign_id}, #{name}, #{value}")
        
        true
      end
      
      def send_test(campaign_id, emails = {}, send_type = nil) 
        Rails.logger.debug("Hominid::TestBase#send_test called with #{campaign_id}, #{emails.inspect}, #{send_type}")
        true
      end
      
      def send(campaign_id)
        Rails.logger.debug("Hominid::TestBase#send called with #{campaign_id}")
        true
      end
      
      def subscribe(list_id, email, merge_vars = {}, options = {})
        Rails.logger.debug("Hominid::TestBase#subscribe called with #{list_id}, #{email.inspect}, #{merge_vars.inspect}, #{options.inspect}")
        
        true
      end
      
      def unsubscribe(list_id, email, options = {})
        Rails.logger.debug("Hominid::TestBase#unsubscribe called with #{list_id}, #{email.inspect}, #{options.inspect}")
        
        true
      end
      
      private
      AllLists = [
        {
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
        },
        {
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
        }, 
        
      ]
      
    end
  end
end