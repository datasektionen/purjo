class FileNodesController < InheritedResources::Base
  def destroy
    destroy! { text_node_files_path(@file_node.parent) }
  end
end