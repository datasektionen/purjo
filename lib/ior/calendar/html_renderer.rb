module Ior
  module Calendar
    class HtmlRenderer
      def initialize(posts, year, month)
        @posts = posts
        @month = month
        @year = year
      end
      
      def render
        headers = ["Måndag", "Tisdag", "Onsdag", "Torsdag", "Fredag", "Lördag", "Söndag"]
        time = Time.utc(@year, @month).beginning_of_week
      
        output = "<table cellpadding=\"0\" cellspacing=\"0\" class=\"calendar\">\n"
        
        
        output += "<thead>\n"
        output += "<tr class=\"dayName\">\n"
        output += "<th class=\"week\">V.</th>\n"
        headers.each { |header|
          output += "<th scope=\"col\">#{header}</th>\n"
        }
        output += "</tr>\n"
        output += "</thead>\n"
        
        
        
        output += "<tbody>\n"
        
        #Avoid the following code if the month starts on a monday
        if time.month != @month
          output += "<tr>\n"    
          output += "<td class=\"week\">#{time.strftime("%W")}</td>\n"

          while time.month != @month
            output += "<td class=\"otherMonth\">"
            output += time.day.to_s
            output += "</td>\n"
            time = time.tomorrow
          end
        end


        while time.month == @month
          if time.wday == 1 #Monday, start a new row
            output += "<tr>\n"
            output += "<td class=\"week\">#{time.strftime("%W")}</td>\n"
          end

          output += "<td class=\"day"
          output += " weekendDay" if time.wday == 0 || time.wday == 6

          if time.day == Time.now.day && time.month == Time.now.month && time.year == Time.now.year
            output += " today"
          end

          output += "\"><p class=\"daynumber\">#{time.day.to_s}</p>"

          #Get all posts that happen during the current day. (Starts on, Ends on or Starts before and Ends after current day)
          posts_this_day = @posts.find_all{ |p| (p.starts_at >= time.beginning_of_day && p.starts_at <= time.end_of_day) ||
                                                (p.starts_at <= time.beginning_of_day && p.ends_at >= time.end_of_day) ||
                                                (p.ends_at >= time.beginning_of_day && p.ends_at <= time.end_of_day) }
          posts_this_day.each { |p|
            output += "<a href=\"/nyheter/#{p.id}\">#{p.to_s}</a>\n"
          }
            
          output += "</td>\n"
            
          if time.wday == 0 #Sunday, end of the row
            output += "</tr>\n"
          end
            
          time = time.tomorrow
        end
        
        
        #If the month ended on a sunday, the </tr> tag has already been inserted, so we
        #don't want another copy of it
        if time.wday != 1
          #Insert days from nect month until we reach a monday
          while time.wday != 1
            output += "<td class=\"otherMonth weekendDay\">#{time.day.to_s}</td>\n"
            time = time.tomorrow
          end
          #Finish the row
          output += "</tr>\n"
        end

        output += "</tbody>\n"
        output += "</table>\n"
        output
      end
    end
  end
end
