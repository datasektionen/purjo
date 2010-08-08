module Ior
  module LiquidFilters
    class MoreInfoField < Liquid::Tag
      # more_info "ior", "/sektionen/ior"
      # more_info "dkm"
      #Syntax = /(#{Liquid::QuotedFragment})\s*#{Liquid::ArgumentSeparator}\s*(#{Liquid::QuotedFragment})/
      
      Syntax = /(#{Liquid::QuotedFragment})(?:\s*#{Liquid::ArgumentSeparator}\s*(#{Liquid::QuotedFragment}))?/
      
      def initialize(tag_name, markup, tokens)
        if markup =~ Syntax
          @committee_slug = LiquidFilters::strip_quotes($1)
          @more_info_url = LiquidFilters::strip_quotes($2) rescue nil
        else
          raise SyntaxError, "Error in tag 'more_info_field' - Valid syntax: more_info_field 'SLUG' [, 'url']"
        end
      end
      
      def render(context)
        out = %q{<div class="more_info">}
        
        if @more_info_url.present?
          out += %Q{<a href="#{@more_info_url}">Mer info</a> | }
        end
        
        out += %Q{<a href="/kontakt/#{@committee_slug}">Kontakt</a>}
        
        out += %q{</div>} 
                
        out.html_safe
      end
    end
  end
end

Liquid::Template.register_tag('more_info_field', Ior::LiquidFilters::MoreInfoField)

