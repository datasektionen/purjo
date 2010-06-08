module TextNodeVersionsHelper

  # Googlade fram den här:   
  # http://markmcb.com/2008/11/04/ruby-on-rails-diff-text-to-html-ins-and-del/
  # Har petat en del på det.
  def diff text_new, text_old
    #set up some variables to reference later
    temporary_directory = File.join(Rails.root, "tmp")
    max_lines = 9999999 #needs to be larger than the most lines you'll consider
    diff_header_length = 3
      
    # since we're using diff on the file system, we'll save the text we want to compare
    # and then run diff against the two files
    file_old_name = File.join(temporary_directory,"file_old"+rand(1000000).to_s)
    file_new_name = File.join(temporary_directory,"file_new"+rand(1000000).to_s)
    file_old      = File.new(file_old_name, "w+")
    file_new      = File.new(file_new_name, "w+")
    file_old.write(text_old+"\n")
    file_new.write(text_new+"\n")
    file_old.close
    file_new.close
      
    # diff will give provide a string showing insertions and deletions.  We will
    # split this string out by newlines if there are difference, and mark it up
    # accordingly with html
    lines = %x(diff -u #{file_old_name} #{file_new_name})
    if lines.empty?
      lines = text_new.split(/\n/)
    else
      lines = lines.split(/\n/)[diff_header_length..max_lines].
      collect do |i|
        if i.empty?  
          ""
        else
          case i[0,1]
          when "+"; then "INSERTED:ROW"+i[1..i.length-1]+"INSERTED-ROW"
          when "-"; then "DELETED:ROW"+i[1..i.length-1]+"DELETED-ROW"
          else; i[1..i.length-1]
          end
        end
      end
    end
      
    #clean up the temporary diff files we created
    File.delete(file_new_name)
    File.delete(file_old_name)
      
    #return marked up text
    str = h lines.join("\n")
    str = str.gsub(/INSERTED:ROW/,"<ins>")
    str = str.gsub(/INSERTED-ROW/,"</ins>")
    str = str.gsub(/DELETED:ROW/,"<del>")
    str = str.gsub(/DELETED-ROW/,"</del>")
    simple_format(str)
  end

end
