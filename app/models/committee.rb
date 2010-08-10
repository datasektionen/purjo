class Committee < ActiveRecord::Base
  searchable do
    text :name
  end
  
  belongs_to :chapter_post

  def functionary_post
    chapter_post
  end
end

