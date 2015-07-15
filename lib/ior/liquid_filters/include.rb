# encoding: utf-8
module Ior
  module LiquidFilters
    # Inkluderar en annan nod i denna nod
    # Syntax: {% include url %}
    #
    # url: url för den nod som ska inkluderas
    class Include < Liquid::Tag
      def initialize(tag_name, markup, tokens)
        @url = LiquidFilters::strip_quotes(markup)
      end
      
      def render(context)
        node = TextNode.find_by_url(@url)
        if node.nil?
          return "Icke-existerande nod #{@url}"
        end
        node.formatted_contents(context.registers[:controller])
      end
    end
    
  end
end

Liquid::Template.register_tag('ior_include', Ior::LiquidFilters::Include)
