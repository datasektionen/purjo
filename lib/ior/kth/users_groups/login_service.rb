require 'net/http'
require 'net/https'
require 'uri'

module Ior
  module KTH
    module UsersGroups
      class LoginService
        attr_reader :service
        
        # service = return URL on successfull logon
        def initialize(service)
          @service = service
        end
        
        def validate_ticket(ticket) 
          result = nil
          
          https = Net::HTTP.new('login.kth.se', 443)
          https.use_ssl = true
          https.start { |w|
            result = w.get("/validate?service=#{@service}&ticket=#{ticket}")
          }
          
          if result.body =~ /yes\n(\w{8})/
            return $1 
          end
          
          return false
        end
        
        def login_url
        	"https://login.kth.se/login?service=#{@service}"
        end
      end
    end
  end
end