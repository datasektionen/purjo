require 'spec_helper'

describe Newsletter do
  before do
    @hominid = mock_hominid
    Hominid::Base.stub(:new).and_return(@hominid)
    @newsletter = Factory(:newsletter_march_2010)
  end
  
  context "on creation" do
    before do
      @valid_params = {
        :subject => "Nyhetsbrevet!"
      }
      
    end
    
    it "creates a Mailchimp campaign and save its id" do
      @hominid.should_receive(:create_campaign).with(hash_including(:subject => "Nyhetsbrevet!")).and_return("deadbeef")
      
      newsletter = Newsletter.create!(@valid_params)
      newsletter.campaign_id.should == "deadbeef"
    end
    
    it "returns textile formatted contents of sections" do
      @newsletter.newsletter_sections.create!(:title => 'Section 1', :body => "Hamstrar")
      @newsletter.newsletter_sections.create!(:title => 'Section 2', :body => "Marsvin")
      
      @newsletter.formatted_content.should include("<h2>Section 1</h2>")
      @newsletter.formatted_content.should include("<p>Hamstrar</p>")
    end
  end
  
  it "starts in state pending" do
    @newsletter.state.should == 'pending'
  end
end
