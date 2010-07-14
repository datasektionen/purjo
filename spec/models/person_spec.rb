require 'spec_helper'

describe Person do
  before do
    @valid_attributes = {
      :first_name => 'Ture',
      :last_name => 'Teknolog',
      :email => 'ture@example.com'
    }
  end
  
  it "creates user setting for the person" do
    person = Person.new(@valid_attributes)
    settings = person.build_user_settings
    settings.person.should == person
  end
  
  it "creates user settings with params for the person" do
    person = Person.new(@valid_attributes)
    UserSettings.should_receive(:new).with(person, hash_including(:newsletter => true))
    settings = person.build_user_settings(:newsletter => true)
  end
end