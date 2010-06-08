module Ior
  module LiquidFilters
    class MenuItem < Liquid::Tag
      Syntax = /(#{Liquid::QuotedFragment})\s*#{Liquid::ArgumentSeparator}\s*(#{Liquid::QuotedFragment})/
      def initialize(tag_name, markup, tokens)
        if markup =~ Syntax
          @text = $1
          @url = $2
          
          @text = LiquidFilters::strip_quotes(@text)
          @url = LiquidFilters::strip_quotes(@url)
        else
          raise SyntaxError, "Error in tag 'item' - Valid syntax: item 'text', '/url'"
        end
      end
      
      def render(context)
        if context['menu_url'].blank?
          raise Liquid::ContextError, "Can't have a item outside a menu block"
        end
        
        url = context['menu_url'] + "/" + @url
        %Q{<li><a href="#{url}">#{@text}</a></li>}
      end
    end
    
  end
end

Liquid::Template.register_tag('item', Ior::LiquidFilters::MenuItem)

