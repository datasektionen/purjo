module FormHelper
  def ior_form_for(record_or_name_or_array, options = {}, &block)
    markup(:form_for, record_or_name_or_array, options.reverse_merge(:builder => Ior::Form::FormBuilder), &block)
  end
  
  def ior_remote_form_for(record_or_name_or_array, options = {}, &block)
    markup(:remote_form_for, record_or_name_or_array, options.reverse_merge(:builder => Ior::Form::FormBuilder), &block)
  end
  
  def markup(method, record_or_name_or_array, options, &block)
    if options[:class]
      concat("<fieldset class=\"#{options[:class]}\">", block.binding)
    else
      concat("<fieldset>")
    end
    concat("<ul>")
    
    self.send(method, record_or_name_or_array, options, &block)
    
    concat("</ul>")
    concat("</fieldset>")
  end
  
end