require 'spec_helper'

describe Person do
  before do
    @valid_attributes = {
      :first_name => 'Ture',
      :last_name => 'Teknolog',
      :email => 'ture@example.com'
    }
  end
  
  context "user settings" do
    before do
      @person = Person.new(@valid_attributes)
      
    end
    it "creates user setting for the person" do
      settings = @person.build_user_settings
      settings.person.should == @person
    end
  
    it "creates user settings with params for the person" do
      UserSettings.should_receive(:new).with(@person, hash_including(:newsletter => true))
      settings = @person.build_user_settings(:newsletter => true)
    end
    
    it "#user_settings returns an user settings object with correct person" do
      settings = @person.user_settings
      settings.should be_a(UserSettings)
      settings.person.should == @person
    end
  end
end