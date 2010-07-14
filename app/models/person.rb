class Person < ActiveRecord::Base
  has_one :kth_account, :dependent => :destroy
  
  has_many :memberships
  has_many :roles, :through => :memberships
  has_many :newsletter_subscriptions do
    def active
      where(:state => 'active').first
    end
  end
  
  accepts_nested_attributes_for :newsletter_subscriptions
  
  validates_presence_of :first_name, :last_name, :email
  
  serialize :serialized_features
  
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
  Role.all.each do |role|
    define_method "#{role.to_s}?" do 
      has_role?(role.to_s)
    end
  end
  
  # Check if a user has a role.
  def has_role?(role)
    list ||= self.roles.map(&:name)
    list.include?(role.to_s) || list.include?('admin')
  end
  
  def features
    self.serialized_features ||= []
    serialized_features
  end
  
  def build_user_settings(attributes = {})
    @user_settings = UserSettings.new(self, attributes)
  end
  
  def has_feature?(feature)
    features.include?(feature.to_s)
  end
    
  # Imports a person into the system with the given UGID. 
  # Returns false if the person is not found.
  def self.import(ugid, catalog = Ior::KTH::UsersGroups::CatalogService.new)
    if (user = catalog.find(ugid)) and not Person.exists?(:kth_ugid => ugid)
      person = Person.new
      person.first_name = user.first_name
      person.last_name = user.last_name
      person.email = user.emails.include?("#{user.username}@kth.se") ? "#{user.username}@kth.se" : user.emails.first
      person.kth_username = user.username
      person.kth_ugid = ugid
      person.save!
      
      return person
    end
    
    return false
  end

  def functionaries
    @functionaries = Functionary.find(:all, :conditions =>
      { :person_id => self.id },
      :order => "active_from desc"
    )
  end
  
end
