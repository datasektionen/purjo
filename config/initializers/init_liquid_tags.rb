Dir[File.join(Rails.root, "lib", "ior", "liquid_filters", "*")].each do |file|
  require file
end

require File.join(Rails.root, "lib", "ior", "liquid_filters.rb")