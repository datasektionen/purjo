class Student < ActiveRecord::Base

  def username
    return username_nada if !username_nada.nil?
    username_kth
  end

  def email
    return username_nada + "@nada.kth.se" if !username_nada.nil?
    username_kth + "@kth.se"
  end

  def plan
    if homedir
      if file_ok(homedir + "/.plan")
        File.open(homedir + "/.plan").to_a.join
      else
        ""
      end
    else
      "no homedir" # Har kvar som debug, man bör aldrig se den
    end
  end

  private

  def file_ok path
    if File.exists?(path) && File.readable?(path)
      return true
    end
    false
  end

end

