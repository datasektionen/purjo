# encoding: utf-8
class Node
  def self.find_by_url(url)
    node = TextNode.find_by_url(url)
    
    if node.nil?
      node = FileNode.find_by_url(url)
    end
    
    node
  end
  
  def self.sanitize_url(url)
    if url.is_a? String
      inurl = url.split(/\//)
    else
      inurl = url
    end
    out = []

    inurl.each do |p|
      out << sanitize_url_part(p)
    end

    if url.is_a? String
      out = out.join("/")
    end

    out
    
  end
  
  def self.sanitize_url_part(url)
    url.mb_chars.gsub(/[åä]/, 'a').gsub(/ö/, 'o').downcase.gsub(/[^a-zA-Z\.0-9\-]+/, "_")
  end
end