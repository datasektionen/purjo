require 'twitter/twitter_item'

class FrontPagesController < ApplicationController
  cache_sweeper :calendar_sweeper, :only => [:show]
  
  def show
    @news_posts = (params[:drafts] ? Post.drafts : Post.published)
    
    if params[:tags]
      @news_posts = Post.tagged_with(params[:tags])
      @active_tags = ActsAsTaggableOn::TagList.from(params[:tags])
    end
    
    @news_posts = @news_posts.paginate(:page => params[:page], :per_page => 5)

    @menu_template = "nyheter"

    now = Time.now
    @current_calendar_posts = Event.between(
      now.beginning_of_day,
      now + Rails.application.settings[:show_n_days_in_calendar].days
    ).order(:starts_at.asc).limit(5)
    
    unless Person.current.anonymous?  
      @user_settings = Person.current.build_user_settings
    end

    @tags = Rails.cache.fetch('tag_list') do
      Post.tag_counts_on(:categories).order("count desc")
    end
  end
  
  def rss
    @news_posts = Post.all
    
    if params[:tags]
      @news_posts = @news_posts.tagged_with(params[:tags])
    end
    
    @news_posts = @news_posts.limit(20)
  end
end
