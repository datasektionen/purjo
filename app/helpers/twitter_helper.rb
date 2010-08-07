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
end
