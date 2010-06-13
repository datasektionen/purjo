module HelperMethods
  def click_admin_link(text)
    within "div#admin_links" do
      click text
    end
  end
end

Rspec.configuration.include(HelperMethods)
