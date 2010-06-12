class CalendarsController < ApplicationController
  def show
    respond_to do |format|
      format.html do
        @month = (params[:month] || Time.now.month).to_i
        @year = (params[:year] || Time.now.year).to_i
        @posts = Post.calendar_posts.for_month(@month, @year)
      end
      
      format.ics do
        posts = Post.calendar_posts.find(:all, :conditions => ["starts_at > ?", Time.now - 60.days])
        renderer = Ior::Calendar::IcsRenderer.new(posts)
        render :text => renderer.render
      end
    end
  end
  
  private
  def vevent(start, stop, content)
    
  end
end
