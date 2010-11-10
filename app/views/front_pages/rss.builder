xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "www.d.kth.se - Nyheter"
    xml.description "Kategorier: #{@active_tags.nil? ? 'Alla' : @active_tags.to_sentence}"
    xml.link posts_url
    
    @posts.each do |post|
      xml.item do 
        xml.title post.name
        xml.description(textilize(post.body))
        
        xml.author post.created_by
        # Tue, 10 Jun 2003 04:00:00 GMT
        xml.pubDate post.created_at.utc.strftime("%a, %d %b %Y %H:%M:%S GMT")
        xml.link post_url(post)
        xml.guid post_url(post)
      end
    end
  end
end
