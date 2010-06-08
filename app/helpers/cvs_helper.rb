module CvsHelper
  def show(cv, name, method)
    result = cv.send(method)
    
    unless result.blank?
      output = "<p><h3>#{name}</h3></p>\n"
      output += "<p>#{cv.send(method)}</p>\n"
    end
  end
  
  def cv_language_links
    Cv::LANGUAGES.map { |language, abbr| link_to language, cvs_path(:language => abbr) }.join(" | ")
  end
end
