require 'net/ldap'
require 'kth/users_groups/user'

module Ior
  module KTH
    module UsersGroups
      class CatalogService
        def find(kthid)
          filter = Net::LDAP::Filter.eq('ugKthid', kthid)
          
          ldap = Net::LDAP.new(:host => Purjo2::Application.settings['ldap_host'], :base => 'ou=Addressbook,dc=kth,dc=se')
          ldap.search(:filter => filter) do |entry|
            user = User.new
            user.first_name = entry.givenname.first
            user.last_name = entry.sn.first
            user.username = entry.ugusername.first
            user.emails = entry.mail.first
            
            return user
          end
          
          return false
        end
      end
    end
  end
end