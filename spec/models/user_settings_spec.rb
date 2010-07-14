require 'spec_helper'

describe UserSettings do
  before do
    @person = Factory(:norbert_nollan)
    @valid_settings = {
      :newsletter => true
    }
  end
  
  describe "newsletter settings" do
    it "creates a newsletter subscription if the settings says so" do
      nus = UserSettings.new(@person, :newsletter => true)
      lambda {
        nus.save!
      }.should change(NewsletterSubscription, :count).by(1)
    end
    
    it "does not create a newsletter subscription if the settings says so" do
      nus = UserSettings.new(@person, @valid_settings.except(:newsletter))
      lambda {
        nus.save!
      }.should_not change(NewsletterSubscription, :count)
    end
    
  end
  
  it "should mark the person as not new when saved" do
    nus = UserSettings.new(@person, {})
    nus.save!
    @person.has_chosen_settings.should == true
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