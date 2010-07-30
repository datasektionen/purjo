# Sunspot uses the method returning, which is remvoed in rails rc.
# This makes the code make sense and work.

raise "This hack is designed for rails rc1. Maybe it is fixed now?" unless Rails.version == '3.0.0.rc'

module Sunspot #:nodoc:
  module Rails #:nodoc:
    # 
    # This module provides Sunspot Adapter implementations for ActiveRecord
    # models.
    #
    module Adapters

      class ActiveRecordDataAccessor < Sunspot::Adapters::DataAccessor
        def options_for_find
          options = {}
          options[:include] = @include unless @include.blank?
          options[:select]  =  @select unless  @select.blank?
          options
        end
      end
    end
  end
end
