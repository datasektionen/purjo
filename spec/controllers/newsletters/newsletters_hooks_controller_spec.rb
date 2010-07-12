require 'spec_helper'

describe NewsletterHooksController do
  context "unsubscribes" do
    
    before do
      @norbert = Factory(:norbert_nollan)
      @newsletter_subscription = @norbert.newsletter_subscriptions.create!
      @newsletter_subscription.stub(:subscribe).and_return(true)
      @newsletter_subscription.process!
    end
    
    it "disables the newsletter subscription" do
      post :mailchimp_endpoint, example_post_data.merge(:secret => 'this is secret')
      
      @norbert.newsletter_subscriptions.active.should == nil
    end
    
    it "does not blow up with no data" do
      post :mailchimp_endpoint, :secret => 'this is secret'
    end
    
    it "returns nothing with incorrect secret" do
      @controller.should_receive(:render).with(:nothing => true)
      @controller.should_receive(:render).with(no_args)
      
      post :mailchimp_endpoint, example_post_data.merge(:secret => 'this is bullcrap')
    end
    
    it "does not do anything with incorrect secret" do
      assigns[:person].should == nil
      post :mailchimp_endpoint, example_post_data.merge(:secret => 'this is bullcrap')
    end
    
    def example_post_data
      {
        "type" => "unsubscribe", 
        "fired_at" => "2009-03-26 21 =>40 =>57", 
        "data" => {
          "id" => "8a25ff1d98", 
          "list_id" => "a6b5da1054",
          "email" => "norbert@example.com", 
          "email_type" => "html", 
          "merges" => {
            "EMAIL" => "norbert@example.com",
            "FNAME" => "MailChimp", 
            "LNAME" => "API", 
            "INTERESTS" => "Group1,Group2"
          },
          "ip_opt" => "10.20.10.30",
          "campaign_id" => "cb398d21d2"
        }
      }
    end
  end
end
