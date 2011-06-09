module Ior
  module Security
    class AccessDenied < StandardError; end 
    
    module AuthenticationSystem
      def authenticate
        if session[:person_id]
          Person.current = Person.find(session[:person_id]) 
        else
          Person.current = AnonymousPerson.new
        end
      end
      
    end 
  end
end
