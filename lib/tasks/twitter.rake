namespace :twitter do
  task :update do
    require 'net/http'
    
    resp = Net::HTTP.get("twitter.com", "/statuses/user_timeline/22768776.rss?count=5") #D-rek
    if resp
      open("app/views/twitter/twitter.rss", "w") { |file|
        file.write(resp)
      }
    end

  end
end
