module DkmHelper
  def list_children(node)
    yield node
    node.children.each { |child| yield child if child.is_a? TextNode }
  end
end