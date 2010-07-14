require 'spec_helper'

describe NewsletterSubscription do
  describe "creating" do
    before do
      @person = Factory(:norbert_nollan)
      @valid_attributes = {
        :person => @person
      }
      @subscription = NewsletterSubscription.new(@valid_attributes)
    end
    
    it "starts in state unprocessed" do
      @subscription.state.should == "unprocessed"
    end
  end
  
  describe "processing" do
    before do
      @person = Factory(:norbert_nollan)
      @valid_attributes = {
        :person => @person
      }
      @subscription = NewsletterSubscription.new(@valid_attributes)
      @hominid = Ior::Hominid::TestBase.new(:api_key => 'cafebabe')
      Ior::Hominid::TestBase.stub(:new).and_return(@hominid)
      
    end
    
    it "subscribes the person" do
      @hominid.should_receive(:subscribe).with("deadbeef", "norbert@example.com")
      @subscription.process
    end
    
    it "goes to state active if everything works" do
      @hominid.stub(:subscribe).and_return(true)
      @subscription.process
      @subscription.state.should == "active"
    end
    
    #it "goes to state failed if hominid fails" do
    #  @hominid.stub(:subscribe).and_return(false)
    #  @subscription.process
    #  @subscription.state.should == "failed"
    #end
    
    it "saves failure reason from hominid on failure"
  end
  
  describe "cancelling" do
    it "unsubscribes from hominid"
    it "goes to state cancelled if unsubscribe successful"
    it "raises error if unsubscribe is unsucessful"
    it "sends email to someone if unsubscribe fails"
  end
end
