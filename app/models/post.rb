class Post < ActiveRecord::Base
  scope :active, :conditions => ["expires_at > ?", DateTime.now]
  
  scope :news_posts, :conditions => ["news_post = ?", true], :order => 'sticky DESC'
  scope :calendar_posts, :conditions => ["calendar_post = ?", true], :order => 'starts_at ASC'
  
  scope :for_month, lambda { |month, year|
    date = DateTime.civil(year, month)
    
    {:conditions => [ 'NOT (ends_at < :start_date OR starts_at > :end_date)', {:start_date => date, :end_date => date.end_of_month}]}
  }
  
  scope :for_day, lambda {|day, month, year|
    date = DateTime.civil(year, month, day)
    
    {:conditions => [ 'NOT (ends_at < :start_date OR starts_at > :end_date)', {:start_date => date.beginning_of_day, :end_date => date.end_of_day}]}
  }
  
  scope :newer_than, lambda { |time| where(['starts_at > ?', Time.now - time]) }

  acts_as_taggable_on :categories
  
  belongs_to :created_by, :class_name => 'Person'
  has_many :noises
  validates_presence_of :starts_at, :ends_at, :if => lambda { |post| post.calendar_post? }
  validate :must_have_either_news_post_or_calendar_post
  validate :start_date_before_end_date

  # after_create :set_perma_name
  
  def to_s
    self.name
  end
  
  def categories_attributes=(attributes)
    self.category_list = attributes.keys.collect{|c| "'#{c}'"} * ', '
  end
  
  def has_comments?
    !noises.empty?
  end

  def comment_count
    noises.size
  end

  private
  def must_have_either_news_post_or_calendar_post
    if !self.calendar_post && !self.news_post
      errors.add_to_base "Inlägget måste antingen vara en nyhet eller en kalenderpost"
    end
  end
  
  def start_date_before_end_date
    return true unless self.calendar_post
    return unless starts_at.present? && ends_at.present?
    
    if self.starts_at > self.ends_at
      errors.add_to_base "Aktiviteten måste börja innan den slutar, doh!"
    end
  end

  def set_perma_name
    self.perma_name = self.name.downcase
    
    {'å' => 'a', 'ä' => 'a', 'ö' => 'o'}.each do |r|
      self.perma_name.gsub!(r.first, r.last)
    end
    
    self.perma_name.gsub!(' ', '-')
    
    self.save
  end

end
