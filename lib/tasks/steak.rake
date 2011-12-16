begin
  require 'rspec/core'
  require 'rspec/core/rake_task'
rescue MissingSourceFile
  module RSpec
    module Core
      class RakeTask
        def initialize(name)
          task name do
            require File.expand_path(File.dirname(__FILE__) + "/../../config/environment")
            raise <<-MSG
#{"*" * 80}
* You are trying to run an rspec rake task defined in
* #{__FILE__}
* but rspec can not be found in vendor/gems, vendor/plugins or system gems.
#{"*" * 80}
MSG

          end
        end
      end
    end
  end
end

namespace :spec do
  desc "Run the code examples in spec/acceptance"
  RSpec::Core::RakeTask.new(:acceptance => "db:test:prepare") do |t|
    t.pattern = "spec/acceptance/**/*_spec.rb"
  end
  
  task :statsetup do
    require 'rails/code_statistics'
    ::STATS_DIRECTORIES << %w(Acceptance\ specs spec/acceptance) if File.exist?('spec/acceptance')
    ::CodeStatistics::TEST_TYPES << "Acceptance specs" if File.exist?('spec/acceptance')
  end
end
