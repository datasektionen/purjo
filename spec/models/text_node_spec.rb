require File.dirname(__FILE__) + '/../spec_helper'

describe TextNode do
  before(:each) do
    @valid_text_node_params = {:custom_layout => nil}
  end
  it "can have a custom layout" do
    tn = TextNode.new(@valid_text_node_params.with(:custom_layout => "test"))
    tn.layout.should eql("test")
  end
  
  it "should use default layout if no custom layout is set" do
    tn = TextNode.new(@valid_text_node_params.with(:custom_layout => nil))
    tn.layout.should eql("application")
  end
end