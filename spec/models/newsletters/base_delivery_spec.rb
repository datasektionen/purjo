require 'spec_helper'

describe DeliveryBase do
  before do
    @hominid = mock_hominid
    Hominid::Base.stub(:new).and_return(@hominid)
    @newsletter = Factory(:newsletter_march_2010)
    
    @delivery = DeliveryBase.new(@newsletter)
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
      DeliveryBase.new(mock_model(Newsletter))
    end
  end
  
end