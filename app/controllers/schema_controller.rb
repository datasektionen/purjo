#require 'memcache_util'
#require 'schema/event'
#require 'schema/providers/time_edit_event'

class SchemaController < ApplicationController
  caches_action :index
  
  @@years = { 'D1' => 19516000, 'D2' => 25263000, 'D3' => 14673000}
  
  
  def index
    raise 'Cannot find specified year' if not @@years.include? params[:year]
        
    start = Date.today - Date.today.cwday + 1
    stop = start + 180
    stop = stop + (7-stop.cwday)
    
    @colourize = Colourize.new
    
    @dates = start...stop
    @dates = @dates.group_by { |x| x.cweek }
    
    service = Ior::Schema::Service.new
    
    @events = service.find(:start => start, :stop => stop, :objects => @@years[params[:year]])
    @events = @events.sort_by { |e| [e.start, e.stop] }
    
    respond_to do |format|
      format.html do
        @events = @events.group_by { |e| e.start.to_date }
        @events.each do |key,events|
          list = []
          
          while not events.empty?
            list << optimize_grouping(group_intersecting_events(events.shift, events))
          end
          
          @events[key] = list
        end
        
        render :layout => false
      end
    end
  end
  
  def proxy
    url = URI.parse('http://schema.sys.kth.se')
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.get('/4DACTION/iCal_downloadReservations/timeedit.ics?'.concat(params.collect { |k,v| "#{k}=#{CGI::escape(v.to_s)}" }.join('&')))
    }

    respond_to do |format|
      format.ics { render :text => res.body, :encoding => :ascii }
    end
  rescue Errno::ECONNREFUSED, Errno::ECONNRESET => e
    render :text => "Timeedit seems to be down!", :status => :service_unavailable
  end
  
  private 
  
  def group_intersecting_events(current, stack)
    return [current] if stack.empty?
    return [current] if not (stack.first.start >= current.start and stack.first.start < current.stop)
    
    return [current] + group_intersecting_events(stack.shift, stack)
  end
  
  def optimize_grouping(events)
    columns = []
    columns << [events.shift]
    
    events.each { |event| place_in_column(event, columns) }
    
    return columns
  end
  
  def place_in_column(event, columns)
    for column in columns
      if event.start >= column.last.stop
        column << event
        return
      end
    end
    
    columns << [event]
  end
  
  class Colourize
    def initialize
      @colours = ['#cceaf9', '#ffd4a3', '#e4edb2', '#e4edf3', '#aaddff', '#d8e1a9' ]
      @used = {}
    end
    
    def color(event)
      key = nil
      key = event.name[0...4] if not event.name.nil?
      
      @used[key] = @colours.shift if not @used.include? key
      @used[key]
    end
  end
end