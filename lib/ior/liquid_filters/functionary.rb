# encoding: utf-8
module Ior
  module LiquidFilters
    class Functionary < Liquid::Tag
      
      def initialize(tag_name, markup, tokens)
        @chapter_post_slug = markup
      end
      
      def render(context)
        post = ChapterPost.find_by_slug(@chapter_post_slug)
        
        return "Ingen sådan post finns" if post.nil?
        
        functionaries = post.functionaries.active
        
        return "Ingen på posten" if functionaries.empty?
        
        functionaries.collect {|f| f.person.try :name }.to_sentence
      end
    end
  end
end

Liquid::Template.register_tag('functionary', Ior::LiquidFilters::Functionary)
