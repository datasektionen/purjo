require 'spec_helper'

describe TestDelivery do
  before do
    @hominid = mock_hominid
    Hominid::Base.stub(:new).and_return(@hominid)
    @newsletter = Factory(:newsletter_march_2010)
    
    @delivery = TestDelivery.new(@newsletter, :email => 'patrik@example.com')
  end

  context "performing" do
    before do
      @hominid.stub(:update).and_return(true)
      @newsletter.stub(:formatted_content).and_return("hamstrar")
      @newsletter.stub(:campaign_id).and_return("deadbeef")
    end
    
    it "does not perform job on invalid delivery" do
      @delivery.stub(:valid?).and_return(false)
      @delivery.perform.should == false
    end
    
    it "returns true on success" do
      @delivery.perform.should == true
    end
    
    it "updates campaign with content" do
      @hominid.should_receive(:update).with("deadbeef", "content", hash_including("html_CONTENT" => "hamstrar"))
      
      @delivery.perform
    end
    
    it "does the test sending" do
      @hominid.should_receive(:send_test).with("deadbeef", ["patrik@example.com"])
      
      @delivery.perform
    end
    
    it "doesn't test send the newsletter if the update fails" do
      @hominid.stub(:update).and_return(false)
      @hominid.should_not_receive(:send_test)
      @delivery.perform
    end
  end
end