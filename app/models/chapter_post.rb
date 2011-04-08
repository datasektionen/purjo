class ChapterPost < ActiveRecord::Base

  has_many :functionaries
  has_one :committee

  validates_presence_of :name, :slug
  validates_uniqueness_of :slug

  scope :ordered, order("name")

  # Någon som känner behovet att eliminera sql:en, varsegod. Föresatt att den
  # gör samma sak och är lika effektiv.
  def find_chapter_posts_by_kth_username username
    @chapter_posts = ChapterPost.find_by_sql(
      "select chapter_posts.id, chapter_posts.name, chapter_posts.slug,
              chapter_posts.description, people.kth_username,
              chapter_posts.updated_at
       from chapter_posts
       join functionaries on chapter_post_id = chapter_posts.id
       join people on person_id = people.id
       where kth_username = '#{username}'
       group by name
       order by updated_at"
      )
  end

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
