module Ior
  module Form
    class FormBuilder < ActionView::Helpers::FormBuilder
      
      def text_field(method, options = {})
        options[:size] ||= nil
        row(method, options) do
          super(method, options)
        end
      end

      def text_area(method, options = {})
        options[:rows] ||= 7
        options[:cols] ||= 19
        row(method, options) do
          super(method, options)
        end
      end

      def display(method, options = {})
        row(method, options) do
          @object.send(method)
        end
      end

      def password_field(method, options = {})
        row(method, options) do
          super(method, options)
        end
      end

      def select(method, choices, options = {}, html_options = {})
        row(method, options) do
          super(method, choices, options, html_options)
        end
      end

      def select_or_add_new(method, choices, options = {}, html_options = {})
        options[:disable] ||= "new_#{method.to_s}"
        html_options[:onchange] = "var value = $F(this); $('#{options[:disable]}').getElementsBySelector('input, textarea, select').each(function(input){ if(value == ''){ input.enable(); } else { input.disable(); }});" + html_options[:onchange].to_s
        select method, choices.unshift(["Add new...", ""]), options, html_options
      end

      def check_box(method, options = {})
        row(method, options) do
          super(method, options)
        end
      end

      def file_field(method, options = {})
        row(method, options) do
          super(method, options)
        end
      end

      def datetime_select(method, options = {})
        row(method, options) do
          super(method, options)
        end
      end

      def date_select(method, options = {})
        row(method, options) do
          super(method, options)
        end
      end
      #fields_for(record_or_name_or_array, *args, &block)  public  
      def fields_for(record_or_name_or_array, *args, &block)
        super
      end

      def submit(method, options = {})
        output = "<li class=\"submit_li\"><div>#{super(method, options)}"

        if options[:cancel_link]
          output += "<p> eller #{options[:cancel_link]}</p>"
        end

        output += "</div></li>"
      end
      
      def textile_editor(method, options = {})
        editor_id = options[:id] || '%s_%s' % [object_name, method]
        mode = options.delete(:simple) ? 'simple' : 'extended'
        output = []
        output << text_area(method, options)
        output << %{<script type="text/javascript" charset="utf-8">}
        output << %{Event.observe(window, 'load', function() \{}
        output << %q{TextileEditor.initialize('%s', '%s');} % [editor_id, mode || 'extended']
        output << %[});]
        output << "</script>"
        
        output.join "\n"
        
      end
      
      private
      def row(method, options = {}, &block)
        caption = options.delete(:caption) || method.to_s.humanize
        
        caption += "*" if options[:mandatory]
        
        output = "<li>#{label(method, caption, options)}#{yield}" 
        
        if options[:suffix]
          output += "<span class='suffix'>#{options[:suffix]}</span>"
        end
        
        output += "</li>"
      end

      def has_many_through_checkbox(association_name, choice, options)
        output = ""

        output += choice.name
        output += check_box_tag "#{@object_name}[#{association_name.to_s.singularize}_ids][]", choice.id, @object.send("#{association_name.to_s.singularize}_ids").include?(choice.id)

        output
      end
    end
  end
end