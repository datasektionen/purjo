class FileNode < ActiveRecord::Base
  #has_attachment :storage => :file_system
  
  belongs_to :parent, :class_name => 'TextNode', :foreign_key => 'parent_id'
  
  before_validation :update_url
  
  def name
    filename
  end
  
  def name=(value)
    filename = value
  end
  
  protected
  def update_url
    node = self
    
    if node.parent.nil?
      self.url = ""
      return
    end
    
    if self.name.nil?
      errors.add "name", "must be set"
      return
    end
    
    url_parts = [self.name]
    
    # Låt oss inte skriva ut namnet på root-noden
    while node.parent != nil and node.parent.parent != nil
      url_parts << node.parent.name
      node = node.parent
    end
    
    sanitized_parts = Node.sanitize_url(url_parts)
    url = "/" + sanitized_parts.reverse.join("/")
    
    self.url =  url
    
  end
  
end
