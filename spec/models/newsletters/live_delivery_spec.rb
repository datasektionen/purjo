require 'spec_helper'

describe LiveDelivery do
  before do
    @hominid = Ior::Hominid::TestBase.new(:api_key => 'cafebabe')
    Ior::Hominid::TestBase.stub(:new).and_return(@hominid)
    @newsletter = Factory(:newsletter_march_2010)
    
    @valid_params = {
      :list_id => Ior::Hominid::TestBase::ListId
    }
    
    @delivery = LiveDelivery.new(@newsletter, @valid_params)
  end
  
  it "#subscriber_count" do
    @delivery.subscriber_count.should == Ior::Hominid::TestBase::SubscriberCount
  end
  
  it "#list_name" do
    @delivery.list_name.should == Ior::Hominid::TestBase::ListName
  end
  
  it "#list" do
    @delivery.list['id'].should == Ior::Hominid::TestBase::ListId
  end
  
  it "fetches #list from the list_id attribute" do
    @delivery = LiveDelivery.new(@newsletter, @valid_params.with(:list_id => '1f3c1d4b9d'))
    @delivery.list['name'].should == 'Ior'
  end
  
  context "creating" do
    it "requires list" do
      delivery = LiveDelivery.new(@newsletter, @valid_params.except(:list_id))
      delivery.should_not be_valid
    end
  end
  
  context "performing" do
    before do
      @hominid.stub(:update).and_return(true)
      @newsletter.stub(:formatted_content).and_return("hamstrar")
      @newsletter.stub(:text_content).and_return("texthamstrar")
      @newsletter.stub(:campaign_id).and_return("deadbeef")
    end
    
    it "does not perform job on invalid delivery" do
      @delivery.stub(:valid?).and_return(false)
      @delivery.perform.should == false
    end
    
    it "returns true on success" do
      @delivery.perform.should == true
    end
    
    it "updates campaign with html content" do
      @hominid.should_receive(:update).with("deadbeef", "content", hash_including("html_CONTENT" => "hamstrar"))
      
      @delivery.perform
    end
    
    it "updates campaign with text content" do
      @hominid.should_receive(:update).with("deadbeef", "content", hash_including("text" => "texthamstrar"))
      
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

