class Student < ActiveRecord::Base
  
  # So this is a hack to work around the fact that Person and Student isn't the same thing.
  # It enables searches on the posts the Student/Person has
  has_one :person, :class_name => "Person", :foreign_key => "kth_username", :primary_key => "username_nada" 

  searchable do
    text :name
    text :username_nada
    text :chapter_posts, :stored => true do
      if person.present?
        person.functionaries.map { |f| f.chapter_post.name }.join " "
      end
    end
    
    text :committees, :stored => true do
      if person.present?
        person.functionaries.map { |f| f.chapter_post.committee.name }.join " "
      end
    end
    
  end
  
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

