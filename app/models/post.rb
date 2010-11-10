class Post < ActiveRecord::Base
  default_scope :order => 'COALESCE(posts.published_at, posts.created_at) desc'
  scope :published, :order => "posts.published_at desc",
    :conditions => ["posts.published_at IS NOT NULL AND posts.published_at <= ?", Time.now]
  scope :drafts, :conditions => ["posts.published_at IS NULL OR posts.published_at > ?", Time.now]

  acts_as_taggable_on :categories
  
  belongs_to :created_by, :class_name => 'Person'
  has_many :noises

  validates_presence_of :name
  
  searchable do
    text :content
    text :name, :default_boost => 2
    string :tags, :multiple => true, :using => :categories
    time :published_at
  end

  attr_writer :draft
  def draft; @draft || published_at.blank?; end
  before_validation :clear_published_at_if_draft
  
  def to_s
    self.name
  end

  # body (stripped of section markup)
  def body
    content.gsub(/\s*---\s*/, "\n\n")
  end

  # content sections
  def sections
    sections = content.split(/\s*---\s*/)
    return content.split(/(\r?\n){2,}/, 2) if sections.length < 2
    sections
  end

  # excerpt (first section optionally followed by read more link if there is more)
  def excerpt(more_link = false)
    s = sections
    return "" if s.length < 1
    if s.length > 1 && more_link
      s.first << ' <a href="/nyheter/' + id.to_s +
        '" class="read-more">Läs&nbsp;resten&nbsp;&raquo;</a>'
    end
    s.first
  end
  
  def has_comments?
    !noises.empty?
  end

  def comment_count
    noises.size
  end

  def editable?
    Person.current.admin? || (Person.current.editor? && created_by == Person.current)
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

  def clear_published_at_if_draft
    self.published_at = nil if draft == 'true'
  end
end
