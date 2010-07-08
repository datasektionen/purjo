require 'spec_helper'

describe Person do
  before do
    @valid_attributes = {
      :first_name => 'Ture',
      :last_name => 'Teknolog',
      :email => 'ture@example.com'
    }
  end
  
  it "only has one active newsletter subscription"
  it "has one active and one cancelled newsletter subscription"
end