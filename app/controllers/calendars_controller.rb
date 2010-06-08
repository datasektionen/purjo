class CalendarsController < ApplicationController
  def show
    respond_to do |format|
      format.html do
        @month = (params[:month] || Time.now.month).to_i
        @year = (params[:year] || Time.now.year).to_i
        @posts = Post.calendar_posts.for_month(@month, @year)
      end
      
      format.ics do
        output = "BEGIN:VCALENDAR\n"
        output += "VERSION:2.0\n"
        output += "X-WR-CALNAME:Kongl. Datasektionen\n"
        output += "PRODID:-//hacksw/handcal//NONSGML v1.0//EN\n"
        
        Post.calendar_posts.find(:all, :conditions => ["starts_at > ?", Time.now - 60.days]).each do |post|
          output += "BEGIN:VEVENT\n"
          
          if post.all_day
            output += "DTSTART:#{(post.starts_at + 1.hour).utc.strftime("%Y%m%d")}\n"
            output += "DTEND:#{(post.ends_at + 1.day - 1.hour).utc.strftime("%Y%m%d")}\n"
          else
            output += "DTSTART:#{post.starts_at.utc.strftime("%Y%m%dT%H%M%SZ")}\n"
            output += "DTEND:#{post.ends_at.utc.strftime("%Y%m%dT%H%M%SZ")}\n"
          end
          
          output += "SUMMARY:#{post.name}\n"
          output += "DESCRIPTION:#{post.content_plain.gsub("\n", "\\n")}\n"
          output += "END:VEVENT\n"
        end
        
        output += "END:VCALENDAR\n"
        
        render :text => output
      end
    end
  end
  
  private
  def vevent(start, stop, content)
    
  end
end
