require 'twitter/twitter_item'

class FrontPagesController < ApplicationController
  def show
    @posts = (params[:drafts] ? Post.drafts : Post.published)
    
    if params[:tags]
      @posts = @posts.tagged_with(params[:tags].gsub('%', ''))
      @active_tags = ActsAsTaggableOn::TagList.from(params[:tags])
    end
    
    page = params[:page].to_i; page = 1 if page < 1
    @posts = @posts.paginate(:page => page, :per_page => 5)

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
      Post.published.tag_counts_on(:categories).order("count desc").all
    end
    # apparentely the cache process freezes the object... this ugly hack circumvents that
    @tags = @tags.dup if @tags.frozen?

    # fix for exception raising when odd formats are requeted
    if request.format != Mime::HTML
      raise ActionController::RoutingError, "Invalid output format (#{params[:format].inspect}) requested."
    end
  end
  
  def rss
    @posts = Post.published
    
    if params[:tags]
      @posts = @posts.tagged_with(params[:tags])
      @active_tags = ActsAsTaggableOn::TagList.from(params[:tags])
    end
    
    @posts = @posts.limit(20)
  end
end
