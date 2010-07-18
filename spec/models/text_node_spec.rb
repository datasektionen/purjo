require 'spec_helper'

describe TextNode do
  before do
    
  end
  
  describe "#deletable?" do
    before do
      @root = Factory(:root_page)
      @about = Factory(:about_page)
    end
    
    it "is deletable without children" do
      @about.should be_deletable
    end
    
    it "is not deletable when it has child nodes" do
      child = @about.children.create!(:name => 'child', :contents => 'blubblubbb')
      @about.should_not be_deletable
    end
    
    it "is not deletable when it is the root node" do
      @root.should_not be_deletable
    end
  end
  
  describe "destruction" do
    it "does not destroy itself if marked as undeletable" do
      @root = Factory(:root_page)
      @root.stub(:deletable?).and_return(false)
      @root.destroy
      @root.should_not be_destroyed
    end
  end
end