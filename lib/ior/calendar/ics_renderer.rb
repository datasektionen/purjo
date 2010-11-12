module Ior
  module Calendar
    class IcsRenderer
      def initialize(events)
        @events = events
      end
      
      def render
        output = "BEGIN:VCALENDAR\r\n"
        output += "VERSION:2.0\r\n"
        output += "X-WR-CALNAME:Kongl. Datasektionen\r\n"
        output += "PRODID:-//hacksw/handcal//NONSGML v1.0//EN\r\n"
        output += "X-WR-TIMEZONE:Europe/Stockholm\r\n"
        output += "TZID:Europe/Stockholm\r\n"
        
        @events.each do |event|
          output += "BEGIN:VEVENT\r\n"
          
          if event.all_day || (event.ends_at - event.starts_at) >= 24.hours
            output += "DTSTART;VALUE=DATE:#{(event.starts_at).strftime("%Y%m%d")}\r\n"
            output += "DTEND;VALUE=DATE:#{(event.ends_at).strftime("%Y%m%d")}\r\n"
          else
            output += "DTSTART:#{event.starts_at.strftime("%Y%m%dT%H%M%S")}\r\n"
            output += "DTEND:#{event.ends_at.strftime("%Y%m%dT%H%M%S")}\r\n"
          end
          
          output += "SUMMARY:#{event.name}\r\n"
          output += fix_description(event.content.gsub("\\", "\\\\").gsub(";", "\\;").gsub(",", "\\,"))
          output += "END:VEVENT\r\n"
        end
        
        output += "END:VCALENDAR\r\n"
        output
      end
      
      def fix_description(content)
        result = "DESCRIPTION:"
        counter = 0
        content.each_line { |line|
          l = line.strip
          result += " " unless counter == 0
          result += l
          result += "\r\n"
          counter+= 1
        }
        if counter == 0 #No description
          return ""
        else 
          return result
        end
      end
    end
  end
end
