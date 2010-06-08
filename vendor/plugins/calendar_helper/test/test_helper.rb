require 'rubygems'
require 'test/unit'
require 'flexmock/test_unit'
require 'fileutils'

$:.unshift Gem.searcher.find('actionpack').full_gem_path + '/lib/action_controller/vendor/html-scanner'
require 'active_support'
require 'action_view'

$:.unshift File.expand_path(File.dirname(__FILE__) + "/resources")

require 'responsible_markup/responsible_markup'

require File.expand_path(File.dirname(__FILE__) + "/../lib/calendar_helper")

