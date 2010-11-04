class Post < ActiveRecord::Base
  default_scope :order => "posts.created_at desc"
  scope :published, :order => "posts.published_at desc",
    :conditions => ["posts.published_at IS NOT NULL AND posts.published_at <= ?", Time.zone.now]

  acts_as_taggable_on :categories
  
  belongs_to :created_by, :class_name => 'Person'
  has_many :noises

  validates_presence_of :name
  
  searchable do
    text :content
    text :name, :default_boost => 2
    string :tags, :multiple => true, :using => :categories
  end

  # after_create :set_perma_name
  
  def to_s
    self.name
  end
  
  def has_comments?
    !noises.empty?
  end

  def comment_count
    noises.size
  end

  private

  def set_perma_name
    self.perma_name = self.name.downcase
    
    {'å' => 'a', 'ä' => 'a', 'ö' => 'o'}.each do |r|
      self.perma_name.gsub!(r.first, r.last)
    end
    
    self.perma_name.gsub!(' ', '-')
    
    self.save
  end

  def categories_new
    ''
  end

end
