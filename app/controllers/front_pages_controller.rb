class FrontPagesController < ApplicationController
  include Ior::Posts::NewsPostParamsFinder
  
  def show
    @news_posts, @tags, @archive = find_news_post_by_params(params)

    @now = Time.now

    @calendar_posts = Post.calendar_posts.find(:all, 
      :conditions => ["starts_at > ? AND ends_at < ?", @now, @now + Purjo2::Application.settings['show_n_days_in_calendar'].days])
      
    @new_user_settings = NewUserSettings.new(Person.current)
  end
end
