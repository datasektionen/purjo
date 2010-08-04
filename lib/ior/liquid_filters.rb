module Ior
  module LiquidFilters
    def self.strip_quotes(string)
      string.gsub(/^\s*('|")(.*)('|")\s*$/, '\2')
    end
  end
end

Dir[Rails.root + "lib/ior/liquid_filters/*.rb"].each do |f|
  require f
end