
module Twitter
  class TwitterItem
    attr_reader :pubDate, :text
    def self.get
      items = []
      open(Rails.root + 'app/views/twitter/twitter.rss') do |file|
        response = file.read
        result = ::RSS::Parser.parse(response, false)
        result.items.each {|item| items << new(item) }
      end
      items
    end
    
    def initialize(rss_item)
      @rss_item = rss_item
      @text = @rss_item.title
      @pubDate = rss_item.pubDate
    end
        
    def author
      @rss_item.author.slice(/^\w{1,15}/)      
    end
  end

end