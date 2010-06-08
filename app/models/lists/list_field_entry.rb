class ListFieldEntry < ActiveRecord::Base
  belongs_to :list_entry
  belongs_to :list_field
  
  def value
    if list_field.kind == "longer_text"
      read_attribute(:text)
    else
      read_attribute(:value)
    end
  end
  
  def value=(value)
    if list_field.kind == "longer_text"
      write_attribute(:text, value)
    else
      write_attribute(:value, value)
    end
  end
  
  def <=>(other)
    value <=> other.value
  end
end
