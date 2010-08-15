module PeopleHelper

  def xfinger_path(person)
    url_for(:controller => "people", :action => "xfinger_image", :uid => person, :only_path => false)
  end
end

