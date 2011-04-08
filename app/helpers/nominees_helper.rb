module NomineesHelper
  # Outputta en länk till innehavaren av en nuvarande funktionärspost 
  def functionary_person_link(chapter_post)
    if chapter_post.functionary
      link_to chapter_post.functionary.person
    else
      "Vakant"
    end
  end

  # Länka till en nominerad person
  def nominee_person_link(nominee)
    link_string = case nominee.status
    when 1
      "<strong>#{nominee.person}</strong>"
    when 2
      "<del>#{nominee.person}</del>"
    else
      nominee.person.to_s
    end

    link_to raw(link_string), nominee.person
  end
end
