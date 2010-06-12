module Authentication
  def login_as(factory_name)
    person = Factory(factory_name)
    Person.stub(:current).and_return(person)
  end
end

class ApplicationController < ActionController::Base
  def authenticate
    Person.current = AnonymousPerson.new
  end
end
