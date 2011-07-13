class ChapterPost < ActiveRecord::Base

  has_many :functionaries
  has_one :committee

  validates_presence_of :name, :slug
  validates_uniqueness_of :slug

  scope :ordered, order("name")

  scope :find_by_kth_username, lambda { |username|
    joins(:functionaries => :person).where("people.kth_username" => username)
  }

  # Använd ej, använd functionary
  def current_functionary chapter_post
    current = DateTime.now
    
    @functionary = Functionary.find(:first, :conditions =>
        ["chapter_post_id = ? and active_from <= ? and active_to >= ?", chapter_post.id, current, current]
    )

    @functionary
  end
  
  # Använd ej, använd functionary
  def current_functionary_name chapter_post
    @functionary = current_functionary chapter_post
    if @functionary
      @functionary.person
    end
  end

  def functionary
    functionaries.active.first
  end
  
  def to_s
    self.name
  end

  def to_param
    slug
  end
end
