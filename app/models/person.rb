class Person < ActiveRecord::Base
  has_one :kth_account, :dependent => :destroy
  
  has_many :memberships
  has_many :roles, :through => :memberships
  has_many :newsletter_subscriptions do
    def active
      where(:state => 'active').first
    end
  end
  
  has_many :functionaries
  
  accepts_nested_attributes_for :newsletter_subscriptions
  
  validates_presence_of :first_name, :last_name, :email, :kth_username
  
  serialize :serialized_features
  
  searchable do
    text :name 
    text :kth_username
    text :chapter_posts_text, :stored => true do
      functionaries.map { |f| f.chapter_post.name }.join " "
  
    end
    
    text :committees_text, :stored => true do
      functionaries.map { |f| f.chapter_post.committee.present? && f.chapter_post.committee.name }.join " "
    end
  end
  
  
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
  
  def user_settings
    UserSettings.new(self)
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

  def gravatar_url
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(self.kth_username + '@kth.se')}?d=mm"
  end
  
  # Methods for compatibility with Student interface (fold)
  def sektion
    chapter
  end
  deprecate :sektion => 'use chapter instead'
  
  def username_nada
    kth_username
  end
  deprecate :username_nada => 'use kth_username'
  
  def username_kth
    kth_ugid
  end
  deprecate :username_kth => 'use kth_ugid'
  
  def uid
    kth_ugid
  end
  deprecate :uid => 'use kth_ugid'
  # (end)
  
  # Methods copied from Student (fold)
  def username
    return username_nada if !username_nada.nil?
    username_kth
  end

  #def email
  #  return username_nada + "@nada.kth.se" if !username_nada.nil?
  #  username_kth + "@kth.se"
  #end

  def plan
    if homedir
      if file_ok(homedir + "/.plan")
        File.open(homedir + "/.plan").to_a.join
      else
        ""
      end
    else
      "no homedir" # Har kvar som debug, man bör aldrig se den
    end
  end

  def file_ok(path)
    if File.exists?(path) && File.readable?(path)
      return true
    end
    false
  end
  
  # (end)

end
