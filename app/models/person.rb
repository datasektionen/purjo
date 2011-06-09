#require 'ior/kth/users_groups/catalog_service'

class Person < ActiveRecord::Base

  validates_presence_of :first_name, :last_name, :email, :kth_username

  
  def name
    "#{first_name} #{last_name}"
  end
  
  def to_param
    kth_username
  end
  
  def to_s
    name
  end
  
  def self.find_or_import(ugid)
    Person.find_by_kth_ugid(ugid) or Person.import(ugid)
  end
  
  def self.current
    @current
  end
  
  def self.current=(current)
    @current = current
  end
  
  def anonymous?
    false
  end
  
  # Use some dynamic programming voodo for syntactic sugar
  ['admin'].each do |role|
    define_method "#{role.to_s}?" do 
      has_role?(role.to_s)
    end
  end
  
  # Check if a user has a role.
  def has_role?(role)
    true
  end
  
end
