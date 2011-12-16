require 'spec_helper'

describe NoiseObserver do
  context "after_create" do
    it "should send recipients to the post author" do
      CommentMailer.should_receive(:notify)
      noise = Factory :noise
      news_post = noise.post

      noise.save!
      NoiseObserver.instance.send(:after_create, noise)
    end
  end
end

