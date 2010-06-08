class StudentsController < ApplicationController
  # GET /students
  # GET /students.xml

  layout 'application'

  def index

    #
    # Parsa en söksträng och returnera students som matchar sökningen
    # @param q - söksträngen från sök teknolog
    #
    @students = nil
    unless params[:q].nil?

      #Kolla om det finns en aktiv mörklaggning
      dark = is_morklaggning

      #Följande strängar kan användas i sökningen för att
      #söka på specifika fält, google style ex: 'user:snilsson'
      search_options = { "sekt" => "sektion", "user" => "username_nada", "uid" => "uid" }

      #Iterera över söksträngen (splittad på space) ooch bygg upp en conditions-array för databassökning
      conditions = [""]
      drifvarconditions = ""
      params[:q].split.collect do |item|
        #om söksträngen inte är en specialsökning, sök på namn och användarnamn
        if !item.match(/:/)
          #sökning på namn och användarnamn
          conditions[0] += '(name LIKE ? OR username_nada LIKE ? OR username_kth LIKE ?) AND '
          3.times{ conditions << ('%' + item + '%') }
        else
          #om det är en specifik sökning, splitta ut söktyp och söksträng
          tmp = item.split(':')
          #avbryt om det inte är en giltig sökning
          if search_options.key? tmp[0] and tmp.size == 2
            conditions[0] += search_options[tmp[0]] + ' LIKE ? AND '
            conditions << tmp[1]
          end
        end

        if dark and !item.match(/:/)
          #sökning på drifvarnamn
          drifvarconditions += 'EXISTS (SELECT * FROM `morklaggnings` WHERE `morklaggnings`.username = `students`.username_nada AND `morklaggnings`.drifvarname LIKE ? ) AND '
          1.times{ conditions << ('%' + item + '%') }
        end

      end

      #avbryt om inga conditions skapats
      if !conditions[0].empty?
        #ta bort sista 'AND '
        conditions[0] = conditions[0][0..-5]
        if dark
          #kombinera två sökningar, dels stäng av vanlig sökning
          #för alla morklaggda och lägg till sökning på drifvarnamn
          conditions[0] = "(" << conditions[0] << ") AND NOT EXISTS (SELECT * FROM `morklaggnings` WHERE `morklaggnings`.username = `students`.username_nada)"
          if !drifvarconditions.empty?
            conditions[0] = conditions[0] + " OR (" << drifvarconditions[0..-5] << ")"
          end
        end

        #logger.debug conditions.join(',')
        @students = Student.find(:all, :conditions => conditions, :limit => 50)

        if dark
          drifvare = get_drifvare

          @students.each do |student|
            if drifvare.key? student.username_nada
              # Drifvare funnen
              student.name = drifvare[student.username_nada]
              student.sektion = "DRIF" # Viktigt att det är just DRIF
              student.username_nada = student.id.to_s
            end
          end

          # Inget illa ment Erik, men det är inte ok med ett sådan användarnamn nu :)
          @students.delete_if { |item| item.username_nada == "konglig" }
        end

        # Skickar vidare direkt till show om det bara blev en träff
        redirect_to :action => 'show', :id => @students[0].username_nada and return if @students.size == 1
        @students
      end
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @students }
    end
  end

  # GET /students/1
  # GET /students/1.xml
  def show

    # T.ex. drifvarna laddas med id-nummer
    if params[:id].match(/\d+/)
      @student = Student.find(params[:id])
    else
      @student = Student.find_by_username_nada(params[:id])
    end
    
    raise ActiveRecord::RecordNotFound if @student.nil?

    if is_morklaggning

      drifvare = get_drifvare

      if drifvare.key? @student.username_nada
        # Drifvare funnen
        @student.name = drifvare[@student.username_nada]
        @student.sektion = "DRIF" # Viktigt att det är just DRIF
        @student.username_nada = @student.id.to_s
      end
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @student }
    end
  end

  # Används av vyn students#show för att visa xfinger-bild
  def xfinger

    # T.ex. drifvarna laddas med id-nummer
    if params[:id].match(/\d+/)
      @student = Student.find(params[:id])
    else
      @student = Student.find_by_username_nada(params[:id])
    end
    
    raise ActiveRecord::RecordNotFound if @student.nil?

    xfinger = nil
    if @student.homedir
      if file_ok(@student.homedir + "/.bild")
          xfinger = @student.homedir + "/.bild"
      elsif file_ok('/afs/nada.kth.se/misc/hacks/graphic/bitmaps/xfinger' + @student.homedir.gsub(/.*\/home/,''))
          xfinger = '/afs/nada.kth.se/misc/hacks/graphic/bitmaps/xfinger' + @student.homedir.gsub(/.*\/home/,'')
      end
    end

    if xfinger.nil?
      xfinger = "public/images/xfinger-notfound.png"
    end

    send_file(xfinger, :disposition => "inline")
  end

  private

  def file_ok path
    if File.exists?(path) && File.readable?(path)
      return true
    end
    false
  end

  def is_morklaggning
    begin 
      start = Settings.find_by_key("morklaggning_start_date").value
      stop = Settings.find_by_key("morklaggning_end_date").value
      start = start.split '-' 
      stop = stop.split '-' 
      if (Date.new(start[0].to_i,start[1].to_i,start[2].to_i) <= Date.today and Date.new(stop[0].to_i,stop[1].to_i,stop[2].to_i) >= Date.today)
        return true
      end
    rescue #if anything goes wrong (nil-value, invalid date, etc) return false
      return false
    end
    return false
  end
end

def get_drifvare
  drifvare = Hash.new
  Morklaggning.all.each do |drif|
    drifvare[drif.username] = drif.drifvarname
  end
  drifvare
end
