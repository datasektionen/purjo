# encoding: utf-8
class Article < ActiveRecord::Base
  belongs_to :blog
  belongs_to :author, :class_name => "Person", :foreign_key => "author_id"
  
  def to_param
    "#{id}-#{perma_name}"
  end
  
  protected
    def perma_name
      perma_name = title.downcase

      # convert öäå
      perma_name.gsub!(/äåÄÅ/, 'a')
      perma_name.gsub!(/öÖ/, 'o')
      
      # remove wierd characters
      perma_name.gsub!(/[^a-z\s]/, '')
      
      # convert whitespace
      perma_name.strip!
      perma_name.gsub!(/\s+/, '_')
            
      perma_name
    end
end
