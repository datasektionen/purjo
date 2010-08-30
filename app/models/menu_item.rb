class MenuItem < ActiveRecord::Base
  belongs_to :text_node, :foreign_key => 'parent_id'
  has_one :text_node 
end
