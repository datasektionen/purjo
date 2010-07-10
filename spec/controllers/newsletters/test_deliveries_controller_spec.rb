require 'spec_helper'

describe TestDeliveriesController do
  context "test deliveries" do
    context "api error in new" do
      before do
        @newsletter = mock_model(Newsletter)
        Newsletter.stub(:find).and_return(@newsletter)
        TestDelivery.stub(:new).and_raise(Hominid::UserError.new(XMLRPC::FaultException.new("104", "Invalid Mailchimp API Key: Foobar-us1")))
      end
    
      it "renders a proper error message" do
        get :new, :newsletter_id => 1
        response.should render_template("error")
      end
    end
  
    context "successful create" do
      before do
        @newsletter = mock_model(Newsletter)
        Newsletter.stub(:find).and_return(@newsletter)
        @test_delivery = mock("TestDelivery")
        @test_delivery.stub(:perform).and_return(true)
        TestDelivery.stub(:new).and_return(@test_delivery)
      end
    
      it "redirects to the newsletter page" do
        post :create, :test_delivery => {:email => 'kaka@example.com'}, :newsletter_id => @newsletter.id
        response.should be_redirect
      end
      
      it "contacts peforms the newsletter delivery" do
        @test_delivery.should_receive(:perform).and_return(true)
        post :create, :test_delivery => {:email => 'kaka@example.com'}, :newsletter_id => @newsletter.id
      end
    end
  
    context "failed create" do
      before do
        @newsletter = mock_model(Newsletter)
        Newsletter.stub(:find).and_return(@newsletter)
        @test_delivery = mock("TestDelivery")
        TestDelivery.stub(:new).and_return(@test_delivery)
      end
    
      [Hominid::CommunicationError, Hominid::APIError].each do |error_class|
        it "renders template for #{error_class.to_s}" do
          @test_delivery.stub(:perform).and_raise(error_class.new(XMLRPC::FaultException.new(300, "Foo")))
          post :create, :test_delivery => {:email => 'kaka@example.com'}, :newsletter_id => @newsletter.id
          response.should render_template('error')
        end
      end
    end
  end
end