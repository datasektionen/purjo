require 'spec_helper'

describe LiveDelivery do
  before do
    @hominid = mock_hominid
    Hominid::Base.stub(:new).and_return(@hominid)
    @newsletter = Factory(:newsletter_march_2010)
    
    @delivery = LiveDelivery.new(@newsletter)
  end
  
  context "performing" do
    before do
      @hominid.stub(:update).and_return(true)
      @newsletter.stub(:formatted_content).and_return("hamstrar")
      @newsletter.stub(:campaign_id).and_return("deadbeef")
    end
    
    it "updates campaign with content" do
      @hominid.should_receive(:update).with("deadbeef", "content", hash_including("html_CONTENT" => "hamstrar"))
      
      @delivery.perform
    end
    
    it "does the test sending" do
      @hominid.should_receive(:send).with("deadbeef")
      
      @delivery.perform
    end
    
    it "doesn't send the newsletter if the update fails" do
      @hominid.stub(:update).and_return(false)
      @hominid.should_not_receive(:send)
      @delivery.perform
    end
    
    it "updates state to sent when sent" do
      @delivery.perform
      @newsletter.state.should == "sent"
    end
    
    it "does changes state to failed if hominid fails" do
      @hominid.stub(:send).and_return(false)
      @delivery.perform
      @newsletter.state.should == 'failed'
    end
  end
end

