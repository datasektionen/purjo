require 'spec_helper'

describe UserSettings do
  before do
    @person = Factory(:norbert_nollan)
    @valid_settings = {
      :newsletter => "1"
    }
  end
  
  describe "newsletter settings" do
    before do
      @hominid = Ior::Hominid::TestBase.new(:api_key => 'cafebabe')
      Ior::Hominid::TestBase.stub(:new).and_return(@hominid)
    end
    
    it "creates a newsletter subscription if the settings says so and person have no subscription" do
      nus = @person.build_user_settings(:newsletter => "1")
      lambda {
        nus.save!
      }.should change(NewsletterSubscription, :count).by(1)
    end
    
    it "does not create a newsletter subscription when not checked and no newsletter subscription" do
      nus = @person.build_user_settings(@valid_settings.with(:newsletter => "0"))
      lambda {
        nus.save!
      }.should_not change(NewsletterSubscription, :count)
    end
    
    it "unsubscribes if newsletter is unchecked and person have subscription" do
      @person.newsletter_subscriptions.create!
      @person.newsletter_subscriptions.first.process!
      
      @hominid.should_receive(:unsubscribe).with(Ior::Hominid::TestBase::ListId, 'norbert@example.com')
      
      nus = @person.build_user_settings(@valid_settings.with(:newsletter => "0"))
      nus.save!
      @person.newsletter_subscriptions.active.should == nil
    end
    
    it "does not subscribe again if there already is an active subscription" do
      @person.newsletter_subscriptions.create!
      @person.newsletter_subscriptions.first.process

      nus = @person.build_user_settings(@valid_settings)
      
      @hominid.should_not_receive(:unsubscribe)
      lambda {
        nus.save!
      }.should_not change(NewsletterSubscription, :count)
    end
  end
  
  it "should mark the person as not new when saved" do
    nus = @person.build_user_settings
    nus.save!
    @person.has_chosen_settings.should == true
  end
  
  it "with no newsletter subscription, newsletter is false" do
    @person.user_settings.newsletter.should == false
  end
  
  it "with newsletter subscription, newsletter is false" do
    @person.newsletter_subscriptions.create!
    @person.newsletter_subscriptions.first.process
    @person = Person.find(@person.id)
    @person.user_settings.newsletter.should == true
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
      UserSettings.new(mock_model(Person), {})
    end
  end
  
end