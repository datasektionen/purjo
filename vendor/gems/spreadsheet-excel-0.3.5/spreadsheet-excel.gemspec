require "rubygems"

spec = Gem::Specification.new do |s|
   s.name        = "spreadsheet-excel"
   s.version     = "0.3.5"
   s.summary     = "Creates Excel documents on any platform"
   s.description = "Creates Excel documents on any platform"
   s.author      = "Hannes Wyss"
   s.email       = "hannes.wyss@gmail.com"
   s.homepage    = "http://rubyspreadsheet.sf.net"
   s.platform    = Gem::Platform::RUBY
   s.files       = Dir.glob("*/**/*").delete_if{ |d|
   	d.include?("CVS")
   	d.include?(".project")
   	d.include?(".cvsignore")
  	}
   s.test_file   = "test/ts_all.rb"
   s.has_rdoc    = true
   s.extra_rdoc_files = ["README","CHANGES"]
end

if $0 == __FILE__
   Gem.manage_gems
   Gem::Builder.new(spec).build
end
