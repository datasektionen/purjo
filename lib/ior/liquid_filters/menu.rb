module Ior
  module LiquidFilters
    class Menu < Liquid::Block
      def initialize(tag_name, markup, tokens)
        @menu_url = markup.blank? ? ".." : LiquidFilters::strip_quotes(markup)
        super
        
      end
      
      def render(context)
        out = []
        context.stack do
          context['menu_url'] = @menu_url
          out << '<div id="submenu">'
          out << '<ul style="list-style-image: url(/images/icon_square.gif);">'
          out << render_all(@nodelist, context)
          out << "</ul>"
          out << "</div>"
        end
        
        out.join("\n")
      end
    end
    
  end
end

Liquid::Template.register_tag('menu', Ior::LiquidFilters::Menu)

