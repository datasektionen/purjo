module Ior
  module Calendar
    class IcsRenderer
      def initialize(posts)
        @posts = posts
      end
      
      def render
        output = "BEGIN:VCALENDAR\n"
        output += "VERSION:2.0\n"
        output += "X-WR-CALNAME:Kongl. Datasektionen\n"
        output += "PRODID:-//hacksw/handcal//NONSGML v1.0//EN\n"
        
        @posts.each do |post|
          output += "BEGIN:VEVENT\n"
          
          if post.all_day
            output += "DTSTART:#{(post.starts_at + 1.hour).utc.strftime("%Y%m%d")}\n"
            output += "DTEND:#{(post.ends_at + 1.day - 1.hour).utc.strftime("%Y%m%d")}\n"
          else
            output += "DTSTART:#{I18n.l post.starts_at, :format => "%Y%m%dT%H%M%SZ" }\n"
            output += "DTEND:#{I18n.l post.ends_at, :format => "%Y%m%dT%H%M%SZ"}\n"
          end
          
          output += "SUMMARY:#{post.name}\n"
          output += "DESCRIPTION:#{post.content.gsub("\\", "\\\\").gsub("\n", "\\n").gsub(";", "\\;").gsub(",", "\\,")}\n"
          output += "END:VEVENT\n"
        end
        
        output += "END:VCALENDAR\n"
        output
      end
    end
  end
end
