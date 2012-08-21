module PeopleHelper
  def xfinger_image(person)
    image_tag("http://www.csc.kth.se/hacks/new/xfinger/image.php?user=#{person.kth_username}", :alt => "xfinger-bild för #{person.to_s}", :title => "xfinger", :width => 266, :class => "xfinger")
  end
end

