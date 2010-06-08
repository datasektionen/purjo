module Ior
  module Schema
    class Event
      attr_accessor :start, :stop, :name, :locations, :type
      
      def initialize
        self.locations = []
      end
      
      def to_s
      "#{name} (#{start - stop})"
      end
      
      def to_ical
        vcf  = "BEGIN:VEVENT\r\n"
        vcf << "DTSTART:#{start.strftime('%Y%m%dT%H%M%S')}\r\n"
        vcf << "DTEND:#{stop.strftime('%Y%m%dT%H%M%S')}\r\n"
        vcf << "SUMMARY:#{name}, #{type}\r\n"
        vcf << "LOCATION:#{locations.to_sentence(:connector => 'och', :skip_last_comma => true)}\r\n"
        vcf << "END:VEVENT\r\n"
        vcf
      end
    end
  end
end