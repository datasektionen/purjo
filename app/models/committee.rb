class Committee < ActiveRecord::Base
  belongs_to :chapter_post

  def functionary_post
    chapter_post
  end
end

