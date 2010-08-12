require 'open-uri'
require 'iconv'

# Open-URI gnäller om ovesäntligheter
module OpenSSL;module SSL;remove_const :VERIFY_PEER; VERIFY_PEER = VERIFY_NONE; end; end

class LunchController < ApplicationController
  def index
    begin
      @date = params[:date] ? Date.parse(params[:date]) : Date.today
    rescue ArgumentError
      render :text => 'Ogiltigt datum', :layout => true
      return
    end

    begin
      str = open("https://www.kth.se/internt/lunch/day_menu.asp?date=" + @date.to_s).read
    rescue OpenURI::HTTPError, Errno::ECONNREFUSED => e
      render :inline => "Ett fel uppstod vid kontakt med lunch-tjänsten: #{e}", :layout => true
    end
    str = Iconv.conv("utf-8", "ISO-8859-1", str)
    
    re = /<A href=\"restaurant_menu.asp.*?>(.*?)<\/A><\/TD><\/TR>|<TR><TD width=\"40\".*?><I>(.*?)<\/I>.*?<\/TD><TD align=\"left\".*?>(.*?)&nbsp;<\/TD>/m
    matches = str.scan(re)
    
    @restaurants = []
    restaurant = nil
    matches.each do |m|
      if m[0]
        @restaurants.push(restaurant) if restaurant
        restaurant = {:name => m[0], :meals => []}
      else
        restaurant[:meals].push({:name => m[1], :description => m[2]})
      end
    end
  end
end
