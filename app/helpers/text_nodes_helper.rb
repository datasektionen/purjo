module TextNodesHelper
  def include_node(url)
    node = TextNode.find_by_url(url)
    if node.nil?
      ""
    else
      node.formatted(self)
    end
  end
end
