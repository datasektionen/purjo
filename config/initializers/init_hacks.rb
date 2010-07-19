Dir[Rails.root + "lib/hacks/*rb"].each do |f|
  puts "Initializing #{File.basename(f)}"
  require f
end
