class TravelYear < ActiveRecord::Base
  has_many :cvs
  serialize :serialized_company_users, Hash
  serialize :serialized_project_members, Array
  
  def company_users
    serialized_company_users || {}
  end
  
  def project_members
    serialized_project_members || []
  end
end
