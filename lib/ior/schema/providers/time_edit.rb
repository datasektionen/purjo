require 'icalendar'

module Ior
  module Schema
    module Providers
      class TimeEdit
        include Icalendar
        
        def find(args)
          start = args.delete(:start)
          stop = args.delete(:stop)
          
          objects = [args[:objects]].compact.flatten
          objects << [args[:course_instance]].compact.flatten.collect{|ic| get_internal_id(ic) }

          find_events(start, stop, objects.flatten)
        end
        
        protected
        # Gets the internal ID of a course instance in TimeEdit
        def get_internal_id(course_instance)
          url = "/4DACTION/WebShowSearch/2/1-0?wv_type=148&wv_category=0&wv_search=#{course_instance}&wv_bSearch=S%F6k"
          response = Net::HTTP.get('schema.sys.kth.se', url)
          response =~ /addObject\((\d+)\)/ ? $1.to_i : nil
        end
        
        def find_events(start, stop, objects)
          start = start.strftime('%y%U')
          stop = stop.strftime('%y%U')
          
          url =  "/4DACTION/iCal_downloadReservations/timeedit.ics?"
          url << "from=#{start}&to=#{stop}&branch=2&lang=1"
          objects.each_with_index { |obj, index| url << "&id#{index + 1}=#{obj}" }

          body = Net::HTTP.get('schema.sys.kth.se', url)

          # multiple calendars can be defined in the same file, this
          # is not the case here so we simple get the first one.
          calendars = Icalendar.parse(body)
          calendar = calendars.first

          # translate to current Ior event definition
          calendar.events.collect do |e| 
            ie = Ior::Schema::Event.new
            ie.start = e.dtstart
            ie.stop = e.dtend
            ie.name = e.summary
            ie.locations = (e.location || '').split(',')
            ie
          end
        end       
      end
    end
  end
end