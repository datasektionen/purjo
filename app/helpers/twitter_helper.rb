module TwitterHelper
  def tweet_to_html(tweet)
    message = String.new(tweet)
    
    tweet.scan(/@\w{1,15}/) {|match| #Mentions
      name = match.slice(/\w{1,15}/)
      message.sub!(match, (link_to match, "http://twitter.com/#{name}"))
    }

    tweet.scan(/#\w+/) {|match| #Hashtags
      message.sub!(match, (link_to match, "http://twitter.com/search?q=%23#{match[1..-1]}"))
    }

    tweet.scan(/http\:\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}[\/a-zA-Z0-9\-\.]*/) {|match| #URL
      message.sub!(match, (link_to match, match))
    }
    return message
  end

end
