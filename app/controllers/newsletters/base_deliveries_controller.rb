class BaseDeliveriesController < ApplicationController
  before_filter :load_parent
  require_role :adminn
  
  def new
    begin
      @delivery = delivery_class.new(@newsletter)
    rescue Hominid::CommunicationError, Hominid::APIError => e
      render 'deliveries_base/error'
    end
  end
  
  def create
    @delivery = new_delivery_with_params(@newsletter)
    
    begin
      if @delivery.perform
        redirect_to newsletters_path
      else
        render :action => 'new'
      end
    rescue Hominid::CommunicationError, Hominid::APIError => e
      @error = e.message
      @error_class = e.class.to_s
      render 'deliveries_base/error'
      return
    end
    
  end
  
  private
  
  def load_parent
    @newsletter = Newsletter.find(params[:newsletter_id])
  end
  
  def new_delivery_with_params(newsletter)
    delivery_class.new(newsletter, params[delivery_class_name.to_sym] || {})
  end
  
  def delivery_class_name
    delivery_class.to_s.underscore
  end
end