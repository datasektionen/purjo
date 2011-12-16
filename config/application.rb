require File.expand_path('../boot', __FILE__)

require 'rails/all'

# If you have a Gemfile, require the gems listed there, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env) if defined?(Bundler)

module Purjo2
  class Application < Rails::Application
    attr_accessor :settings
    
    if Rails.env == 'production' || ENV['ENABLE_REFRACTION'].present?
      config.middleware.insert_before(::Rack::Lock, ::Refraction)
    end
    
    config.i18n.default_locale = :sv

    config.time_zone = 'Stockholm'

    config.autoload_paths += %W(#{config.root}/lib)

    config.active_record.observers = :noise_observer

    # Configure generators values. Many other options are available, be sure to check the documentation.
    # config.generators do |g|
    #   g.orm             :active_record
    #   g.template_engine :erb
    #   g.test_framework  :test_unit, :fixture => true
    # end

    # Configure the default encoding used in templates for Ruby 1.9.
    config.encoding = "utf-8"

    # Configure sensitive parameters which will be filtered from the log file.
    config.filter_parameters += [:password]
    
    paths.app.models << "app/models/newsletters"
    
    paths.app.controllers << "app/controllers/newsletters"
  end
end

require 'ior/liquid_filters'
require 'rss/2.0'

