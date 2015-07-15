# encoding: utf-8
#!/usr/bin/env ruby
require 'ftools'
require 'rubygems'
require 'activerecord'
require 'yaml'
require 'iconv'
require 'net/http'
require './app/models/student.rb'

# Scriptet skapar och uppdaterar Student-objekt i databasen
# med hjälp av den information som finns i passwd-filen
# och information från kåren.
#
# @author Niklas Pedersen
# @updated 2009-05-05 15:11

# Överlagra Logger, så att den skriver ut tid före varje utskrift
class Logger2 < Logger
  def info(param)
    super(Time.now.to_s + ": " + param)
 end
end

# Skapa en logger
log = Logger2.new("/var/log/students.log")
log.info("Påbörjar körning")

# Öppna en anslutning till databasen med hjälp
# av innehållet i database.yml
database = YAML::load(File.open('./config/database.yml'))
ActiveRecord::Base.establish_connection(database["production"])
converter = Iconv.new("UTF8//TRANSLIT", "LATIN1")

# Kopiera passwd-filen till Rails temp-katalog, så att inte afs
# blir ledsen och sparkar ut oss
File.copy("/afs/afs/nada.kth.se/common/yp/passwd", "./tmp/passwd", false)
passwd = File.new("./tmp/passwd","r")

while((s = passwd.gets))
  # Splitta den inlästa raden från passwd-filen på , och :
  arr = s.split(/,|:/)
  # Ta bort alla tomma rader
  arr = arr.delete_if {|x| x == ""}
  
  # Hämta ut data
  id = arr[0]                       # Användarnamn
  name = arr[4]                     # För och Efternamn
  section = arr[5]                  # Sektion/skola
  homedir = arr[arr.length-2]       # Hemkatalog
  
  homesplit = homedir.split(/\//)
  # Kontrollera att det användaren har en giltig hemkatalog
  # En giltig hemkatalog (för studenter) börjar med /afs/*.kth.se/home/
  # följt av en bokstav eller en siffra, eller ett uttryck med minst en 
  # siffra, t.ex. d91
  # Därefter komer deras user id, för nyare studenter u.....
  if !homesplit[4].nil? && (homesplit[4].size == 1 || homesplit[4].match(/[a-z]*[0-9]+/))
    uid = homesplit[5]
    if !uid.nil? && !section.match(/[a-zA-Z\/]+[0-9]{0,2}/).nil? && section.match(/[a-zA-Z\/]+[0-9]{0,2}/)[0] == section && name.match(/Anonymous/).nil?
        
        student = Student.find(:first, :conditions => {:uid => uid})
        updated = false
        
        # Skapa en ny användare, om den inte redan finns, och hoppa över
        # de användare som uppdaterats den senaste månaden
        if student.nil? 
          student = Student.new
          updated = true
          log.info("Skapar användare " + uid)
        else
          next if student.updated_at > ((25+rand(12)).days.ago)
          log.info("Uppdaterar användare " + uid)
        end
        
        # Gå igenom sektionsfältet och ta bort onödig info (som CSC)
        # och ersätt nya koder med de gamla på en bokstav
        s = nil
        section.gsub!(/[0-9x]*/, "").split(/\//).each do |x| 
          s = case
              when (x == "L" || x == "S") then "S"
              when (!x.match(/CL.*/).nil?) then "CL"
              when (x == "ARKIT" || x == "A") then "A"
              when (x == "CBIOT" || x == "C") then "C"
              when (x == "CDATE" || x == "D") then "D"
              when (x == "CDEPR" || x == "P") then "P"
              when (x == "CELTE" || x == "E") then "E"
              when (x == "CFATE" || x == "T") then "T"
              when (x == "CINEK" || x == "I") then "I"
              when (x == "CINTE" || x == "IT") then "IT"
              when (x == "CKEMV" || x == "K" || x == "BIO") then "K"
              when (x == "CMAST" || x == "M") then "M"
              when (x == "CMATD" || x.upcase == "MD") then "MD"
              when (x == "CMETE" || x.upcase == "MEDIA" || x == "TIMEH") then "MEDIA"
              when (x == "CSAMH" || x == "V") then "S"
              when (x == "CTFYS" || x == "F") then "F"
              when (x == "COPEN" || x == "OPEN") then "OPEN"
            end
          break if !s.nil? # Avbryt när en sektion hittats
        end
        section = s
        
        # Anropa THS-databas och hämta in uppgifter om telefonnummer,
        # adress samt kön
        log.info("Kontaktar kåren för användare " + uid)
        Net::HTTP.start('www.ths.kth.se') do |http|
          req = Net::HTTP::Get.new("/res/export/get_member?kthid=" + uid)
          req.basic_auth 'dsekt', 'knarkzebra'
          response = http.request(req)
          @ans = response.body.gsub(/\n/,'').split(/\|/)
          @ans.each do |i|
            i.gsub!(/.*=/,'')
          end
        end
        
        # Kontrollera att sakerna inte är nil eller tomma, så
        # att scriptet inte går sönder när man söker på personer
        # som inte finns i THS databas.
        updated = true if student.phone_home != @ans[4]
        student.phone_home = @ans[4] if (!@ans[4].nil? && !@ans[4].empty?)
        updated = true if student.phone_mobile != @ans[5]
        student.phone_mobile = @ans[5] if (!@ans[5].nil? && !@ans[5].empty?)
        updated = true if student.gender != @ans[7]
        student.gender = @ans[7] if (!@ans[7].nil? && !@ans[7].empty?)
        
        # Slå ihop de tre adressfälten som fås som svar och separera
        # raderna med newline
        adress = ""
        adress = (@ans[8] + "\n") if (!@ans[8].nil? && !@ans[8].empty?) #adr1
        adress += (@ans[9] + "\n") if (!@ans[9].nil? && !@ans[9].empty?) #adr2
        adress += @ans[10] if (!@ans[10].nil? && !@ans[10].empty?) #postnr
        
        updated = true if student.adress != adress
        student.adress = adress
        
        updated = true if student.homedir != homedir
        student.homedir = homedir
        updated = true if student.name != converter.iconv(name)
        student.name = converter.iconv(name)
        updated = true if student.sektion != section
        student.sektion = section
        updated = true if student.uid != uid
        student.uid = uid
        updated = true if student.username_nada != id
        student.username_nada = id
            
        student.save! if updated
        
        # Sov i 2-8 sekunder, för att minska belastningen på THS server
        sleep(2+rand(6))
    end
  end
end

# Ta bort passwd filen, då den inte längre behövs till något
File.delete("./tmp/passwd")
