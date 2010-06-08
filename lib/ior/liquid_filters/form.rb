module Ior
  module LiquidFilters
    # Inkluderar en annan nod i denna nod
    # Syntax: {% include url %}
    #
    # url: url för den nod som ska inkluderas
    class Form < Liquid::Tag
      def initialize(tag_name, markup, tokens)
        @identifier = LiquidFilters::strip_quotes(markup)
      end
      
      def render(context)
        # Avdelningen railskonstigheter: Skriver man bara List hamnar man i dephell
        # Värt att notera:
        #   ::List == List # => true
        # Suck. /spatrik
        list = ::List.find_by_identifier(@identifier)
        if list.nil?
          return "Icke-existerande list: #{@identifier}"
        end
        context.registers[:controller].send(:render_to_string, :partial => 'lists/show_form', :locals => {:list => list})
      end
    end
    
  end
end

Liquid::Template.register_tag('form', Ior::LiquidFilters::Form)
