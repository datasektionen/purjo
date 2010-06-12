class Blog < ActiveRecord::Base
  before_validation :set_perma_name
  validates_uniqueness_of :perma_name, :message => "must be unique. Choose another perma name."
  has_many :articles, :order => "created_at desc"
  
  def to_s
    name
  end
  
  def to_param
    perma_name
  end
  
protected
  def set_perma_name
    self.perma_name = name.downcase if self.perma_name.blank?
    
    # convert öäå
    self.perma_name.gsub!(/äåÄÅ/, 'a')
    self.perma_name.gsub!(/öÖ/, 'o')
    
    # convert whitespace
    self.perma_name.gsub!(/\s/, '_')
  end
end
