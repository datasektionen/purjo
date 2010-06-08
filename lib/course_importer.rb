#!/Users/spatrik/Development/Ior/purjo/script/runner
require 'rubygems'
require 'nokogiri'
require 'open-uri'
require 'set'

class CourseImporter
  def initialize
    @courses = []
    @added_course_codes = Set.new
    
  end
  def import!
    file = open("http://www.kth.se/student/kurser/kurser-per-avdelning")
    
    doc = Nokogiri::HTML(file)
    
    links = doc.css("#article ul li a")
    
    parse_links(links)
    
    Course.transaction do
      Course.delete_all
      @courses.each do |course|
        course.save!
      end
    end
    
  end
  
  def parse_links(links)
    links.each do |link|
      uri = "http://www.kth.se/student/kurser/#{link[:href]}"
      
      section = /avdelning\/(.*)\/kurser/.match(link[:href])[1]
      
      do_course_home_page = true
      
      course_file = open(uri)
      
      doc = Nokogiri::HTML(course_file)
      
      table = doc.css("#article #searchResult table").first
      
      table.css("tr").each do |row|
        next unless row.css("th").size == 0
        parse_course(row, do_course_home_page)
        
      end
    end
    
  end
  
  def parse_course(row, do_course_home_page)
    name, hp, code, level = row.css("td").map { |content| content.content.strip }
    
    unless @added_course_codes.include?(code)
      
      handbook_url = "http://www.kth.se/student/kurser/kurs/#{code}"
      
      course = Course.new(:code => code, :hp => hp.to_f, :level => level, :name => name, :handbook_url => handbook_url)
      
      if do_course_home_page
        parse_course_home_page(course, handbook_url)
      end
      
      @courses << course
      @added_course_codes.add(code)
    end
    
  end
  
  def parse_course_home_page(course, url)
    
    hb_file = open(url)
    
    doc = Nokogiri::HTML(hb_file)
    
    course_home_page = doc.css("#courseHomePage a").first
    
    return if course_home_page.nil?
        
    course.course_home_page = course_home_page[:href]
  end
end

