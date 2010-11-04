require 'ior/calendar/ics_renderer'
require 'ior/calendar/html_renderer'

class CalendarsController < ApplicationController
  def show
    respond_to do |format|
      format.html do
        @month = (params[:month] || Time.now.month).to_i
        @year = (params[:year] || Time.now.year).to_i
        begin
          @events = Event.for_month(@month, @year)
        rescue ArgumentError => e
          render :text => "This doesn't seem like a valid date", :layout => true
        end
      end
      
      format.ics do
        posts = Event.newer_than(60.days)
        renderer = Ior::Calendar::IcsRenderer.new(posts)
        render :text => renderer.render
      end
    end
  end 
end
