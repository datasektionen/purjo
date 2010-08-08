module Ior
  module LiquidFilters
    class Functionary < Liquid::Tag
      
      def initialize(tag_name, markup, tokens)
        @chapter_post_slug = markup
      end
      
      def render(context)
        post = ChapterPost.find_by_slug(@chapter_post_slug)
        
        return "Ingen sådan post finns" if post.nil?
        
        functionary = post.functionaries.active.first
        
        return "Ingen på posten" if functionary.nil?
        
        functionary.person.name
      end
    end
  end
end

Liquid::Template.register_tag('functionary', Ior::LiquidFilters::Functionary)
