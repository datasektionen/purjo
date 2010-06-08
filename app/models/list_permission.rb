class ListPermission < ActiveRecord::Base
  belongs_to :list
  belongs_to :person
end
