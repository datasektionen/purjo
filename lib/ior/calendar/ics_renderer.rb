module Ior
  module Calendar
    class IcsRenderer
      def initialize(events)
        @events = events
      end
      
      def render
        puts "Well, fuck you very much!"
        output = "BEGIN:VCALENDAR\r\n"
        output += "VERSION:2.0\r\n"
        output += "X-WR-CALNAME:Kongl. Datasektionen\r\n"
        output += "PRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\n"
        
        @events.each do |event|
          output += "BEGIN:VEVENT\r\n"
          
          if event.all_day
            output += "DTSTART:#{(event.starts_at).strftime("%Y%m%d")}T000000\r\n"
            output += "DTEND:#{(event.ends_at).strftime("%Y%m%d")}T235959\r\n"
          else
            output += "DTSTART:#{event.starts_at.strftime("%Y%m%dT%H%M%S")}\r\n"
            output += "DTEND:#{event.ends_at.strftime("%Y%m%dT%H%M%S")}\r\n"
          end
          
          output += "SUMMARY:#{event.name}\r\n"
          output += "DESCRIPTION:"
          output += fix_linebreaks(event.content.gsub("\\", "\\\\").gsub(";", "\\;").gsub(",", "\\,"))
          #{event.content.gsub("\\", "\\\\").gsub(";", "\\;").gsub(",", "\\,")}\r\n"
          output += "END:VEVENT\r\n"
        end
        
        output += "END:VCALENDAR\r\n"
        output
      end
      
      def fix_linebreaks(content)
        puts content
        result = ""
        counter = 0
        content.each_line { |line|
          puts line
          l = line.strip
          result += " " unless counter == 0
          result += l
          result += "\r\n"
          counter+= 1
        }
        return result
      end
    end
  end
end
