module HelperMethods
  def click_admin_link(text)
    within "div#admin_links" do
      click text
    end
  end
end

RSpec.configuration.include(HelperMethods)
