class ListField < ActiveRecord::Base
  named_scope :for_list, :conditions => { :show_in_list => true }
  
  has_many :list_field_entry
  belongs_to :list

  acts_as_list :scope => :list_id
  
  validates_presence_of :name, :message => "får inte vara tomt"
  validates_presence_of :value, :message => "får inte vara tomt", :if => lambda { |field| %w{check_boxes radio_buttons}.include?(field.type) }

  def self.avaliable_kinds
    [['Text', 'text'], 
     ['Längre text', 'longer_text'], 
     ['Checkboxar', 'check_boxes'],
     ['Radioknappar', 'radio_buttons']]
  end
end
