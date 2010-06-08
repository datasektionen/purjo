xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0"){
  xml.channel{
    xml.title("Comments on #{@commentable}")
    xml.link(event_path(@commentable))
    xml.description("Comments feed for #{@commentable}")
    xml.language('en-us')
      for comment in @comments
        xml.item do
          xml.description(comment.text)
          xml.author("Your Name Here")               
          xml.pubDate(comment.created_at.strftime("%a, %d %b %Y %H:%M:%S %z"))
          #xml.link(post.link)
          #xml.guid(post.link)
        end
      end
  }
}
