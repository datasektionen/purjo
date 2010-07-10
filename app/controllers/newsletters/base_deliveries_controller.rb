class BaseDeliveriesController < ApplicationController
  before_filter :load_parent
  
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
      @delivery.perform
    rescue Hominid::CommunicationError, Hominid::APIError => e
      @error = e.message
      @error_class = e.class.to_s
      render 'deliveries_base/error'
      return
    end
    redirect_to newsletters_path
  end
  
  private
  
  def load_parent
    @newsletter = Newsletter.find(params[:newsletter_id])
  end
  
  def new_delivery_with_params(newsletter)
    delivery_class.new(newsletter, params[:test_delivery] || {})
  end
end