module Ior
  module LiquidFilters
    class FileList < Liquid::Tag
      def initialize(tag_name, markup, tokens)
        @node_name = LiquidFilters::strip_quotes(markup)
      end
      
      def render(context)
        return "No node specified" if @node_name.blank?
        controller = context.registers[:controller]
        
        puts "OASMFGOASMFASODKFMASPFASDPOFJASDFASDIPFJASD"
        out = "omglol"
        
        out = ["<table>"]
        
        url = controller.request.request_uri
        
        url += "/#{@node_name}" unless @node_name == "."
        
        node = TextNode.find_by_url(url)
        
        return "#{url} does not exist" if node.nil?
        
        out << "<tr>"
        out << "<th>Filename</th>"
        out << "</tr>"
        
        node.file_nodes.each do |file|
          out << "<tr>"
          out << "<td>"
          out << %Q{<a href="#{file.url}">#{file.filename}</a>}
          out << "</td>"
          out << "</tr>"
        end
        
        out << "</table>"
        #context.registers[:controller].send(:render_to_string, :partial => 'lists/show_form', :locals => {:list => list})
        out.join("\n")
      end
    end
    
  end
end

Liquid::Template.register_tag('file_list', Ior::LiquidFilters::FileList)
