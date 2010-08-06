class FrontPagesController < ApplicationController
  def show
    @news_posts = Post.news_posts
    
    @tags = ActsAsTaggableOn::Tag.all
    if params[:tags]
      @news_posts = @news_posts.tagged_with(params[:tags])
      @active_tags = ActsAsTaggableOn::TagList.from(params[:tags])
    end
    
    @news_posts = @news_posts.paginate(:page => params[:page], :per_page => 10)

    @now = Time.now

    @menu_template = "nyheter"

    @calendar_posts = Post.calendar_posts.find(:all, 
      :conditions => ["starts_at > ? AND ends_at < ?", (@now - 7.days).beginning_of_day, @now + Purjo2::Application.settings['show_n_days_in_calendar'].days])
    
    unless Person.current.anonymous?  
      @user_settings = Person.current.build_user_settings
    end
  end
  
  def rss
    @news_posts = Post.news_posts
    
    if params[:tags]
      @news_posts = @news_posts.tagged_with(params[:tags])
    end
    
    @news_posts = @news_posts.limit(20)
  end
end
