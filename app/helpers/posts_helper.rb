module PostsHelper
  def link_tags(tags)
    tags.collect{|c| link_to c, posts_path(:tags => c.name)} * ' '
  end
  
  def calendar_post_date_format(post)
    if post.calendar_post
      if post.all_day
        if post.starts_at.to_date == post.ends_at.to_date
          post.starts_at.strftime "%A %d %B"
        else
          "#{post.starts_at.strftime("%A %d %B")} - #{post.ends_at.strftime("%A %d %B")}"
        end
      else
        "#{post.starts_at.strftime("%A %d %B %H:%M")} - #{post.ends_at.strftime("%H:%M")}"
      end
    end
  end
  
end
