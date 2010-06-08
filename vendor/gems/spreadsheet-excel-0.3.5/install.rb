require "rbconfig"
require "ftools"
include Config

sitedir = CONFIG['sitelibdir']

files = %w/
   format.rb
   olewriter.rb
   biffwriter.rb
   workbook.rb
   worksheet.rb
   excel.rb
/

unless File.exist?("#{sitedir}/spreadsheet")
   Dir.mkdir("#{sitedir}/spreadsheet")
end

files.each{ |file|
   file = "lib/spreadsheet/" + file
   File.copy(file, "#{sitedir}/spreadsheet", true)
}

puts "spreadsheet-excel installed successfully"