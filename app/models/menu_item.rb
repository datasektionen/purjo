class MenuItem < ActiveRecord::Base
  belongs_to :text_node, :foreign_key => 'parent_id'
  belongs_to :text_node 
end
