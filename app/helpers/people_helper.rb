module PeopleHelper
  def zfinger_image(person, width = "256")
    url = "https://zfinger.datasektionen.se"
    image_tag("#{url}/user/#{person.kth_username}/image/#{width}",
              :alt => "zfinger-bild för #{person.to_s}",
              :title => "xfinger",
              :class => "xfinger")
  end
end

