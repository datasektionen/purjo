module Ior
  module LiquidFilters
    # Liquid-tag för att ladda in alla events till en variabel
    # Syntax: {% load_events variabelnamn typer %}
    #
    # variabelnamn: Det variabelnamn i templaten som events ska lagras i
    # typer: kommaseparerad lista av typer (calendar, news, ...?) som ska laddas
    class LoadEvents < Liquid::Tag
      def initialize(tag_name, markup, tokens)
        @var_name, types = markup.split(/\s+/)
        if types.blank?
          @conditions = {}
        else
          types = types.split(",")
          @conditions = {}
          
          types.each do |type|
            @conditions[type] = true
          end
        end
        
      end
      
      def render(context)
        context.scopes.last[@var_name] = Event.find(:all, :conditions => @conditions)
        ''
      end
    end

  end
end

Liquid::Template.register_tag('load_events', Ior::LiquidFilters::LoadEvents)

