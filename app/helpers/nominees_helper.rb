module NomineesHelper

  # todo: gör metoden läslig
  def format_nominees(nominees)
    list = Hash.new

    for n in nominees
      unless list.key? n.chapter_post.name
        list[n.chapter_post.name] = ["","", "", "", ""]
      end

      person = link_to_if n.person, n.person.try(:name), n.person
      key = n.chapter_post.name

      if n.status == 1
        list[key][0] += "<strong>#{person}</strong>"
      elsif n.status == 2
        list[key][0] += "<strike>#{person}</strike>"
      else
        list[key][0] += "#{person}"
      end
      
      if Person.current.editor?
        list[key][0] += " (" + link_to("Redigera", n) + ")<br />"
      else
        list[key][0] += "<br />"
      end

      if n.chapter_post.functionary
        list[key][1] = link_to_if n.chapter_post.functionary.person, n.chapter_post.functionary.person.try(:name), n.chapter_post.functionary.person
      end
      
      list[key][2] = link_to n.chapter_post.name, n.chapter_post
      list[key][3] = n.chapter_post.description
      list[key][4] = n.chapter_post.id
    end

    list
  end

end
