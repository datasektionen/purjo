module Ior
  module Schema
    class Service
      def initialize
        @provider = Schema::Providers::TimeEdit.new
      end

      def find(args = {})
        @provider.find(args)
      end
    end
  end
end