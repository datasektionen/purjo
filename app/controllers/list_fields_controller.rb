class ListFieldsController < ApplicationController
  require_role 'editor'
  def new
    @list_field = ListField.new(params[:list_field])

    respond_to do |format|
      format.rjs do
        render :update do |page|
          if @list_field.valid?
            page.insert_html :bottom, 'fields', :partial => "disabled_#{@list_field.kind}.html.erb", :object => @list_field
          else
            page.alert("ERROR!!1\n#{@list_field.errors.full_messages.map { |m| "- #{m}" }.join("\n")}")
          end
        end
      end
    end
  end
end
