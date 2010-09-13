require 'twitter/twitter_item'

class FrontPagesController < ApplicationController
  cache_sweeper :calendar_sweeper, :only => [:show]
  
  def show
    @news_posts = Post.news_posts
    
    if params[:tags]
      @news_posts = @news_posts.tagged_with(params[:tags])
      @active_tags = ActsAsTaggableOn::TagList.from(params[:tags])
    end
    
    @news_posts = @news_posts.paginate(:page => params[:page], :per_page => 5)

    @menu_template = "nyheter"

    # tag list and tag count in one query
    @tags = ActsAsTaggableOn::Tag.find(:all,
      :select => 'tags.*, count(taggings.id) as tag_count',
      :joins => 'left outer join taggings on tags.id = taggings.tag_id',
      :group => 'tags.id'
    )
    @tags.sort! { |t1, t2| t2.tag_count <=> t1.tag_count }
    @tags = @tags.reject {|t| t.tag_count == 0 }

    now = Time.now
    @current_calendar_posts = Post.calendar_posts.between(
      now.beginning_of_day,
      now + Rails.application.settings[:show_n_days_in_calendar].days
    ).order(:starts_at.asc).limit(5)
    
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
