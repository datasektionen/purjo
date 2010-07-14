require 'spec_helper'

describe FrontPagesController do
  it "does not create user setting for anonymous user" do
    anon_user = AnonymousPerson.new
    UserSettings.should_not_receive(:new)
    get :show
  end
  
  it "creates user setting for logged in user" do
    Person.stub(:current).and_return(Factory(:admin_user))
    UserSettings.should_receive(:new)
    get :show
  end
end