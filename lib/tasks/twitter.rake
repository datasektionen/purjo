namespace :twitter do
  task :update do
    require 'net/http'
    require 'rss/2.0'
    
    users = ['doqumenteriet', 'drektoratet']
    hashtags = ['kthd']
    
    tweets = []
    
    users.each {|user|
      resp = Net::HTTP.get("search.twitter.com", "/search.rss?q=from%3A#{user}")
      if resp
        rss = RSS::Parser.parse(resp, false)
        rss.items.each { |item| tweets << item }
      end
    }

    hashtags.each {|hashtag|
      resp = Net::HTTP.get("search.twitter.com", "/search.rss?q=%23#{hashtag}")
      if resp
        rss = RSS::Parser.parse(resp, false)
        rss.items.each { |item| tweets << item }
      end
    }
    
    tweets = tweets.sort_by {|x| x.pubDate}.reverse
    
    open("app/views/twitter/twitter.rss", "w") { |file|
      file.write('<?xml version="1.0" encoding="UTF-8"?>
<rss version="2.0" xmlns:google="http://base.google.com/ns/1.0" xmlns:openSearch="http://a9.com/-/spec/opensearch/1.1/" xmlns:media="http://search.yahoo.com/mrss/" xmlns:twitter="http://api.twitter.com/">
<channel>')
      tweets[0...5].each {|item|
        file.write(item)
      }
      file.write('</channel></rss>')
    }

  end
end
