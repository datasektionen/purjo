class TestDeliveriesController < ApplicationController
  before_filter :load_parent
  
  def new
    begin
      @test_delivery = TestDelivery.new(@newsletter)
    rescue Hominid::CommunicationError, Hominid::APIError => e
      render 'error'
    end
  end
  
  def create
    @test_delivery = TestDelivery.new(@newsletter, params[:test_delivery])
    
    begin
      @test_delivery.perform
    rescue Hominid::CommunicationError, Hominid::APIError => e
      @error = e.message
      render "error"
      return
    end
    redirect_to newsletters_path
  end
  
  private
  
  def load_parent
    @newsletter = Newsletter.find(params[:newsletter_id])
  end
end