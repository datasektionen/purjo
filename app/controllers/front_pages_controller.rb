require 'twitter/twitter_item'

class FrontPagesController < ApplicationController
  cache_sweeper :calendar_sweeper, :only => [:show]
  
  def show
    @posts = (params[:drafts] ? Post.drafts : Post.published)
    
    if params[:tags]
      @posts = Post.tagged_with(params[:tags])
      @active_tags = ActsAsTaggableOn::TagList.from(params[:tags])
    end
    
    @posts = @posts.paginate(:page => params[:page], :per_page => 5)

    @menu_template = "nyheter"

    now = Time.now
    @events = Event.between(
      now.beginning_of_day,
      now + Rails.application.settings[:show_n_days_in_calendar].days
    ).order(:starts_at.asc).limit(5)
    
    unless Person.current.anonymous?  
      @user_settings = Person.current.build_user_settings
    end

    @tags = Rails.cache.fetch('tag_list') do
      Post.tag_counts_on(:categories).order("count desc")
    end
    # apparentely the cache process freezes the object... this ugly hack circumvents that
    @tags = @tags.dup if @tags.frozen?
  end
  
  def rss
    @posts = Post.all
    
    if params[:tags]
      @posts = @posts.tagged_with(params[:tags])
    end
    
    @posts = @posts.limit(20)
  end
end
