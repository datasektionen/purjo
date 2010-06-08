module Ior
  module KTH
    module UsersGroups
      class User
        attr_accessor :first_name, :last_name, :emails, :username
        
        def inspect
          "#<#{self.class} first_name: #{first_name}, last_name: #{last_name}, emails: #{emails}, username: #{username}>"
        end
      end    
    end
  end
end