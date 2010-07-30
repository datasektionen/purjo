class Committee < ActiveRecord::Base
  searchable do
    text :name
    text :class
  end
  
  belongs_to :chapter_post

  def functionary_post
    chapter_post
  end
end

