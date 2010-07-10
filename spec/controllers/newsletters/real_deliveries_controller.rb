# context "real deliveries" do
#   context "api error in new" do
#     before do
#       @newsletter = mock_model(Newsletter)
#       Newsletter.stub(:find).and_return(@newsletter)
#       NewsletterDelivery.stub(:new).and_raise(Hominid::UserError.new(XMLRPC::FaultException.new("104", "Invalid Mailchimp API Key: Foobar-us1")))
#     end
#   
#     it "renders a proper error message" do
#       get :new, :newsletter_id => 1
#       response.should render_template("error")
#     end
#   end
#   
#   context "successful create" do
#     before do
#       @newsletter = mock_model(Newsletter)
#       Newsletter.stub(:find).and_return(@newsletter)
#       @delivery = mock("NewsletterDelivery")
#       @delivery.stub(:perform).and_return(true)
#       NewsletterDelivery.stub(:new).and_return(@delivery)
#     end
#   
#     it "redirects to the newsletter page" do
#       post :create, :newsletter_id => @newsletter.id
#       response.should be_redirect
#     end
#     
#     it "contacts peforms the newsletter delivery" do
#       @delivery.should_receive(:perform).and_return(true)
#       post :create, :type => 'normal'
#     end
#   end
