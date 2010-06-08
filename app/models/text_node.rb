class TextNode < ActiveRecord::Base
  acts_as_versioned
  #acts_as_textiled :contents
  acts_as_tree
  
  has_many :file_nodes, :foreign_key => 'parent_id'

  before_validation :update_url
  
  validates_uniqueness_of :url
  validates_presence_of :contents
  validates_presence_of :name
  
  def formatted(controller)
    template = Liquid::Template.new
    template.parse(contents)
    #template = Liquid::Template.parse(contents)
    template.registers[:controller] = controller
    redcloth = RedCloth.new(template.render(:filters => [Ior::LiquidFilters]))
    redcloth.no_span_caps = true
    
    redcloth.to_html
  end
  
  def layout
    node = self
    while node.parent != nil
      if !node.custom_layout.blank?
        return node.custom_layout
      end
      node = node.parent
    end
    return "application"
  end
  
  protected
  
  def update_url
    node = self
    
    if node.parent.nil?
      self.url = "/"
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
    
    # Uppdatera barnen
    self.children.each do |child|
      child.update_child_url(self.url)
    end
  end
  
  def update_child_url(parent_url)
    myurl = "#{parent_url}/#{Node.sanitize_url_part(self.name)}"
    
    self.update_attribute(:url, myurl)
    
    self.children.each do |child|
      child.update_child_url(myurl)
    end
  end
  
end

