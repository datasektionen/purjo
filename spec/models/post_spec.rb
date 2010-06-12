require 'spec_helper'

describe Post do
  describe "as calendar post" do
    before do
      @valid_params = {
        :calendar_post => true,
        :content => 'Some event content',
        :name => 'some event title'
      }
    end
  
    it "gives proper error message without end date" do
      post = Post.new(@valid_params.with(:starts_at => 10.days.from_now).except(:ends_at))
      post.should_not be_valid
    end
    
    describe "for ics" do
      before do
        @default_params = {
          :calendar_post => true,
          :content => 'Some event content',
          :name => 'some event title'
        }
        @ancient_post = Post.create!(@default_params.with(:starts_at => 100.days.ago, :ends_at => 99.days.ago))
        @recent_post = Post.create!(@default_params.with(:starts_at => 2.days.ago, :ends_at => 1.day.ago))
        @future_post = Post.create!(@default_params.with(:starts_at => 10.days.from_now, :ends_at => 11.days.from_now))
        @far_future_post = Post.create!(@default_params.with(:starts_at => 100.days.from_now, :ends_at => 101.days.from_now))
      end
    
      it "returns the same thing as legacy code" do
        legacy_results = Post.calendar_posts.find(:all, :conditions => ["starts_at > ?", Time.now - 60.days])
        new_results = Post.calendar_posts.newer_than(60.days)
        legacy_results.should == new_results
      end
      
      it "returns everything in the future" do
        Post.newer_than(60.days).should include(@future_post, @far_future_post)
      end
      
      it "returns recent post" do
        Post.newer_than(60.days).should include(@recent_post)
      end
      
      it "doesn't return ancient post" do
        Post.newer_than(60.days).should_not include(@ancient_post)
      end
    end
  end
end