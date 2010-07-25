module CvsHelper
  def show(cv, name, method)
    result = cv.send(method)
    output = ""
    unless result.blank?
      output += "<p><h3>#{name}</h3></p>\n"
      output += "<p>#{textilize(cv.send(method).to_s)}</p>\n"
    end
    output.html_safe
  end
  
  def cv_language_links
    Cv::LANGUAGES.map { |language, abbr| link_to language, cvs_path(:language => abbr) }.join(" | ").html_safe
  end
end
