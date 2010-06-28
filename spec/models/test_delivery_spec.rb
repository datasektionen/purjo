require 'spec_helper'

describe TestDelivery do
  before do
    @hominid = mock_hominid
    Hominid::Base.stub(:new).and_return(@hominid)
    @newsletter = Factory(:newsletter_march_2010)
    
    @delivery = TestDelivery.new(@newsletter, :email => 'patrik@example.com')
  end

  it "makes the correct template avaiable as #template_name" do
    @delivery.template_name.should == HominidHelpers::TemplateName
  end
  
  it "makes the correct template id avaiable as #template_id" do
    @delivery.template_id.should == HominidHelpers::TemplateId
  end
  
  # Move to separate context?
  it "raises exception if template not found" 
  
  it "#subscriber_count" do
    @delivery.subscriber_count.should == HominidHelpers::SubscriberCount
  end
  
  it "#list_name" do
    @delivery.list_name.should == HominidHelpers::ListName
  end
  
  it "list_id" do
    @delivery.list_id.should == HominidHelpers::ListId
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
      @hominid.should_receive(:send_test).with("deadbeef", ["patrik@example.com"])
      
      @delivery.perform
    end
  end
  
  describe "ActiveModel Lint tests" do
    require 'test/unit/assertions'
    require 'active_model/lint'
    include Test::Unit::Assertions
    include ActiveModel::Lint::Tests

    # to_s is to support ruby-1.9
    ActiveModel::Lint::Tests.public_instance_methods.map{|m| m.to_s}.grep(/^test/).each do |m|
      example m.gsub('_',' ') do
        send m
      end
    end

    def model
      TestDelivery.new(mock_model(Newsletter))
    end
  end
end