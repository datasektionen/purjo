xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title @blog.name
    xml.link blog_articles_url(@blog)
    xml.description @blog.description
    
    @articles.each do |article|
      xml.item do 
        xml.title article.title
        xml.description article.content
        xml.author article.author
        
        # Tue, 10 Jun 2003 04:00:00 GMT
        xml.pubDate article.created_at.utc.strftime("%a, %d %b %Y %H:%M:%S GMT")
        xml.link blog_article_url(@blog, article)
        xml.guid blog_article_url(@blog, article)
      end
    end
  end
end