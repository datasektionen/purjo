require 'twitter/twitter_item'

class FrontPagesController < ApplicationController
  def show
    @news_posts = Post.news_posts
    
    @tags = ActsAsTaggableOn::Tag.all.sort { |t1, t2| t2.taggings.count <=> t1.taggings.count }
    if params[:tags]
      @news_posts = @news_posts.tagged_with(params[:tags])
      @active_tags = ActsAsTaggableOn::TagList.from(params[:tags])
    end
    
    @news_posts = @news_posts.ordered_descending.paginate(:page => params[:page], :per_page => 10)

    @menu_template = "nyheter"

    now = Time.now
    @calendar_posts = Post.calendar_posts.between(
      (now - 7.days).beginning_of_day,
      now + Rails.application.settings[:show_n_days_in_calendar].days
    )
    
    # Fetch 5 calendar posts in the wrong order, then reverse, 
    # to avoid an unnessesary SQL count query.
    @calendar_posts = @calendar_posts.order(:starts_at.desc).limit(5).reverse
    
    unless Person.current.anonymous?  
      @user_settings = Person.current.build_user_settings
    end
  end
  
  def rss
    @news_posts = Post.news_posts.ordered_descending
    
    if params[:tags]
      @news_posts = @news_posts.tagged_with(params[:tags])
    end
    
    @news_posts = @news_posts.limit(20)
  end
end
