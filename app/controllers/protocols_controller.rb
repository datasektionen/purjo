class ProtocolsController < ApplicationController
  # GET /protocols
  # GET /protocols.xml
  def index
    @protocols = Protocol.all
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @protocols }
    end
  end

  # GET /protocols/1
  # GET /protocols/1.xml
  def show
    filename = params[:filename] + "." + params[:format]
    if filename !~ Protocol::VALID_FILENAME
      return access_denied
    elsif filename.ends_with?('.html')
      send_file(Purjo2::Application.settings['protocol_path'] + filename, :type => 'text/html', :disposition => "inline")
    else
      send_file(Purjo2::Application.settings['protocol_path'] + filename)
    end
  end
end



