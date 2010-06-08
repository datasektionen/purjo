module Ior
  module My
    class Settings
      attr_accessor :schedule_link, :course_codes
      
      def courses
        Course.find_all_by_code(course_codes)
        #course_codes.map { |course_code| Course.find_by_code(course_code) }.compact
      rescue
        []
      end
      
      def has_schedule_link?
        schedule_link.present?
      end
      
      def from_hash(hash)
        hash.each_pair do |attribute, value|
          send("#{attribute}=", value)
        end
      end
    end
  end
end
