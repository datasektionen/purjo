module Ior
  module LiquidFilters
    def self.strip_quotes(string)
      string.gsub(/^\s*('|")(.*)('|")\s*$/, '\2')
    end
  end
end
