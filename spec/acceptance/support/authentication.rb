module Authentication
  def login_as(factory_name)
    mock_roles unless Person.respond_to?(:admin?)
    person = Factory(factory_name)
    Person.stub(:current).and_return(person)
    person
  end
  
  def mock_roles
    Factory(:admin_role)
    Factory(:editor_role)
    
    [AnonymousPerson, Person].each do |auth_class| 
      auth_class.class_eval do
        Role.all.each do |role|
          define_method "#{role.to_s}?" do 
            has_role?(role.to_s)
          end
        end
      end
    end
    
  end
end

class ApplicationController < ActionController::Base
  def authenticate
    Person.current = AnonymousPerson.new
  end
end
