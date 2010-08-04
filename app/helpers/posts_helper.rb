module PostsHelper
  def link_tags(tags)
    tags.collect{|c| link_to c, posts_path(:tags => c.name)}.join(' ').html_safe
  end
  
  def calendar_post_date_format(post)
    if post.calendar_post
      if post.all_day
        if post.starts_at.to_date == post.ends_at.to_date
          l(post.starts_at, :format => "%A %d %B").capitalize
        else
          "#{l(post.starts_at, :format => "%A %d %B").capitalize} - #{l(post.ends_at, :format => "%A %d %B")}"
        end
      else
        if post.starts_at.to_date == post.ends_at.to_date
          "#{l(post.starts_at, :format => "%A %d %B %H:%M").capitalize} - #{l(post.ends_at, :format => "%H:%M")}"
        else
          "#{l(post.starts_at, :format => "%A %d %B %H:%M").capitalize} - #{l(post.ends_at, :format => "%A %d %B %H:%M")}"
        end
      end
    end
  end
  
end
