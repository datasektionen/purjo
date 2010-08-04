module TextNodesHelper
  def include_node(url)
    node = TextNode.find_by_url(url)
    if node.nil?
      ""
    else
      node.formatted_contents(self).html_safe
    end
  end
end
