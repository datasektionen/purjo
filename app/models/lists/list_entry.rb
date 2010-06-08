class ListEntry < ActiveRecord::Base
  belongs_to :person
  belongs_to :list
  has_many :list_field_entries
  
  def list_field_entry_params=(field_params)
    field_params.each_pair do |field_id, value|
      list_field = self.list.list_fields.find(field_id)
      list_field_entries.build(:value => value, :list_entry => self, :list_field => list_field)
    end
  end
  
  def method_missing(meth, *args)
    method_name = meth.to_s
    if ( entry = list_field_entries.detect { |e| e.list_field.name == method_name })
      return entry
    end
    
    if list.present? && list.list_fields.detect { |f| f.name == method_name }
      Struct.new("NullField", :value)
      return Struct::NullField.new("NULL")
    end
    super
  end
  
  def respond_to?(meth)
    if list.present? && list.list_fields.detect { |f| f.name == meth.to_s}
      return true
    end
    super
  end
end
