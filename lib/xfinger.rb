##
# Xfinger-modul till STÖn.
# @author Martin Frost
module Xfinger
  # passwd-fil för användare på nada
  PASSWD = "/afs/nada.kth.se/common/yp/passwd"
  # var alla orginal-xfingerbilder ligger 
  XFINGER_IMAGE_DIR = "/afs/nada.kth.se/misc/hacks/graphic/bitmaps/xfinger/"
  # default-bild som kommer synas om det inte finns någon afs-koppling eller om inte användaren har någon xfingerbild
  DEFAULT_IMAGE = "default.jpg"
    
  ##
  # Returnera xfingerbilden för en given användare som länkar till /static/xfinger
  # @param [Person] person Vilken person vi vill ha en xfinger-bild för.
  # @return [String] En länk till en statisk sida med xfingerinformation, med xfinger-bilden för personen som bildtext.
  def xfinger_for(person)
    path = image_path_for(person.kthid)
    path = xfinger_path_for(person, path) unless path == DEFAULT_IMAGE
    link_to(image_tag(path, :width => "120", :alt => "xfinger"), xfinger_path)
  end
  
  ##
  # Få ut plan-information från en nada-användare.
  # @param [String] person Personen ifråga.
  # @return [String] Plan-information för användaren ifråga.
  def plan_for(person)
    begin
      return File.read(home_dir_for(person.kthid) + "/.plan")
    rescue Exception => e
      return "no plan information avalilable"
    end
  end
  
  ##
  # Returnerar hela namnet för en person, som det står i passwd.
  # @param [Person] person Personen ifråga.
  # @return [String] Hela namnet på personen från nadas passwd-fil.
  def name_for(person)
    begin
      return passwd_info_for(person.kthid)[4].split(",")[0]
    rescue Exception => e
      return ""
    end
  end
  
  ##
  # Sektionstillhörighet för en person.
  # @param [Person] person Personen ifråga.
  # @return [String] Sektionsinformation för personen från nadas passwd-fil.
  def chapter_for(person)
    begin
      return passwd_info_for(person.kthid)[4].split(",")[1]
    rescue Exception => e
      return ""
    end
  end
  
  private

  ##
  # Få ut en användares hemkatalog
  # @param [String] uid Användar-id för användaren ifråga.
  # @return [String] En absolut afs-path för var användaren har sin nada-hemkatalog
  def home_dir_for(uid)
    passwd_info_for(uid)[5]
  end

  ##
  # Få ut info om en användare från nadas passwd-fil
  # @param [String] uid Användar-id för användaren ifråga.
  # @return [String] All information som finns i nadas passwd-fil om användaren ifråga.
  def passwd_info_for(uid)
    info = []
    begin
      info = File.read(PASSWD).grep(%r!^#{uid}:!).first.split(":")
    rescue Exception => e      
    end
    return info
  end

  ##
  # Returnerar en path till en xfingerbild för en användare
  # om hemkatalogen inte går att hitta, eller om det inte finns någon .bild i hemkatalogen,
  # så försöker vi kolla efter en orginal-xfingerbild.
  # Finns inte den heller, så returnerar vi en defaultbild (som är ett frågetecken)
  # @param [String] uid Användarnamn för användaren ifråga.
  # @return [String] En absolut afs-path till xfingerbilden för en användare.
  def image_path_for(uid)
    home = home_dir_for(uid)
    
    if !home.nil?
      if File.exists?(home + "/.bild")
        return home + "/.bild"
      elsif File.exist?(XFINGER_IMAGE_DIR)
        home = XFINGER_IMAGE_DIR + home.gsub(/.*\/home/,'')
        return home if File.exist?(home)
      end
    end
    return DEFAULT_IMAGE
  end
  
  ##
  # Absolut path till xfingerbild för en användare
  # @param [Person] person Vilken person vi vill ha en xfinger-url för.
  # @param [String] path Absolut path till användarens xfingerbild.
  # @return [URL] En URL till xfingerbliden för en användare.
  def xfinger_path_for(person, path)
    url_for(:controller => "staff", :action => "xfinger", :path => path, :id => person, :only_path => false)
  end
end