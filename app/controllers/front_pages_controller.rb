class FrontPagesController < ApplicationController
  include Ior::Posts::NewsPostParamsFinder
  
  def show
    @news_posts, @tags, @archive = find_news_post_by_params(params)

    @now = Time.now

    @calendar_posts = Post.calendar_posts.find(:all, 
      :conditions => ["starts_at > ? AND ends_at < ?", (@now - 7.days).beginning_of_day, @now + Purjo2::Application.settings['show_n_days_in_calendar'].days])
    
    unless Person.current.anonymous?  
      @user_settings = Person.current.build_user_settings
    end
  end
end
