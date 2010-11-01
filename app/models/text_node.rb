class TextNode < ActiveRecord::Base
  
  searchable do
    text :name
    text :contents
    text :title, :boost => 2
  end
  #acts_as_versioned
  acts_as_tree
  
  has_many :file_nodes, :foreign_key => 'parent_id'
  has_many :menu_items, :foreign_key => 'parent_id', :order=>'sort_order'

  before_validation :update_url
  before_destroy :deletable?

  validate :unique_url, :on => :create
  validates_presence_of :name
  
  default_scope where(:deleted => false)
  
  def formatted_additional_contents(controller)
    format_text(additional_content, controller)
  end
  
  def formatted_contents(controller)
    format_text(contents, controller)
  end
  
  def format_text(text, controller)
    template = Liquid::Template.new
    template.parse(text)
    #template = Liquid::Template.parse(contents)
    template.registers[:controller] = controller
    
    redcloth = RedCloth.new(template.render(:filters => [Ior::LiquidFilters]))
    redcloth.no_span_caps = true
    redcloth.hard_breaks = false
    
    redcloth.to_html.html_safe
    
  end
  
  def layout
    # hmm, why inherit from parent?
    layout = self.custom_layout
    layout = "text_node_default" if layout.blank?
    return layout

    node = self
    while node.has_parent?
      if !node.custom_layout.blank?
        return node.custom_layout
      end
      node = node.parent
    end
    return "text_node_default"
  end
  
  def deletable?
    children.empty? && parent.present?
  end

  def has_parent?
    !self.parent.nil?
  end
  
  #Returns the menu items for this node and all of it's parents
  def menu
    if self.has_parent?
      menu = self.parent.menu
    else
      menu = {:levels=>0,:items=>Array.new}
    end

    if !self.menu_items.empty?
      menu[:items][ menu[:levels] ] = self.menu_items
      menu[:levels] = menu[:levels]+1
    end

    return menu
  end

  def add_node_to_menu(title,url)
    if !self.menu_items.empty?
      sort_order=self.menu_items.last.sort_order+1
    else
      sort_order=0
    end

    return !MenuItem::create({:parent_id=>self.id,:url=>url,:title=>title,:sort_order=>sort_order}).nil?
  end

  protected
  
  def unique_url
    if TextNode.where(:url => url).count != 0
      errors.add(:name, "already exists under the node #{parent.name}")
    end
  end
  
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

  def destroy
    self.deleted = true
    self.deleted_at = Time.now
    self.save
  end
  
end

