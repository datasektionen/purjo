module NomineesHelper

  # todo: gör metoden läslig
  def format_nominees(nominees)
    list = Hash.new

	# Snyggare sätt att göra den här sorteringen?
	for n in nominees.sort { |a,b| if a.status == b.status then a.person.try(:name) <=> b.person.try(:name) elsif a.status == 1 || b.status == 2 then -1 else 1 end }
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
        list[key][0] += " (" + link_to("Redigera", edit_nominee_path(n)) + ")<br />"
      else
        list[key][0] += "<br />"
      end

      if n.chapter_post.functionary
        if n.chapter_post.functionary.person
          list[key][1] = link_to n.chapter_post.functionary.person.try(:name), n.chapter_post.functionary.person
        else
          list[key][1] = "Vakant"
        end
      end
      
      list[key][2] = link_to n.chapter_post.name, n.chapter_post
      list[key][3] = n.chapter_post.description
      list[key][4] = n.chapter_post.id
    end

    list
  end

end
