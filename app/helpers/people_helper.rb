# encoding: utf-8
module PeopleHelper
  def xfinger_image(person, size = "256x256")
    url = "http://dumnaglar.datasektionen.se/"
    image_tag("#{url}/#{person.kth_username}/#{size}",
              :alt => "xfinger-bild för #{person.to_s}",
              :title => "xfinger",
              :class => "xfinger")
  end
end

