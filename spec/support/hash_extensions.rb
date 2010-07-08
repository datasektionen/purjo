class Hash
  def with(overrides = {})
    self.merge overrides
  end
  
  def only(*keys)
    self.delete_if {|k, v| !keys.include?(k) }
  end
  
  def except(*keys)
    self.delete_if { |k, v| keys.include?(k) }
  end
end
