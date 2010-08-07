require 'rss/2.0'

module TwitterHelper
  def tweet_to_html(tweet)
    msg = String.new(tweet)

    msg.sub!(/\A(\w{1,15}):/) do |match| #Author
      link_to($1, "http://twitter.com/#{$1}", { :class => "author" }) + ":"
    end

    msg.gsub!(/@(\w{1,15})/) do |match| #Mentions
      link_to($&, "http://twitter.com/#{$1}")
    end

    msg.gsub!(/#(\w+)/) do |match| #Hashtags
      link_to($&, "http://twitter.com/search?q=%23#{$1}")
    end

    tweet.scan(/http\:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}[\/a-zA-Z0-9\-\.]*/) do |match| #URL
      msg.sub!(match, link_to(match, match))
    end
    
    return msg
  end
  
  def get_author(string)
    return string.slice(/^\w{1,15}/)
  end
  
  def get_items
    items = []
    open('app/views/twitter/twitter.rss') do |file|
      response = file.read
      result = RSS::Parser.parse(response, false)
      result.items.each {|item| items << item }
    end 
  end
end
