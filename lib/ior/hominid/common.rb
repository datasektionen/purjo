module Ior
  module Hominid
    module Common
      def self.included(base)
        base.send(:attr_reader, :template)
      end
      
      def fetch_template
        @template = hominid.templates.detect { |template| template['id'] == Purjo2::Application.settings[:newsletter_template_id]  }
      end
      
      def hominid
        hominid_class = Purjo2::Application.settings[:newsletter_hominid_class_name].constantize
        hominid_class.new(
          :api_key => Purjo2::Application.settings[:newsletter_api_key],
          :timeout => 60
        )
      end
    end
  end
end