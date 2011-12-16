class Cv < ActiveRecord::Base
  #acts_as_textiled :personal, :ambitions, :employment, :education, :other_commitments, :language_skills, :it_skills, :other

  has_attached_file :photo, :styles => { :thumb => "80x80>", :normal => "200>x200" }
  
  
  
  belongs_to :travel_year

  scope :all, order(:name)
  scope :done, where(:done => true).order(:name)
  
  scope :search, lambda { |term| 
    term = "%#{term}%"
    columns = [:name, :orientation, :personal, :employment, :education, :other_commitments, :it_skills, :other]
    
    conditions = columns.map { |column| "#{column.to_s} LIKE ?" }.join(" OR ")
    
    {
      :conditions => [conditions, ([term] * columns.size)].flatten
    }
  }
  
  # When adding a language, don't forget to add the corresponding locale
  LANGUAGES = [["Swedish", "sv"], ["English", "en"]]

  LANGUAGES.each do |language, abbr|
    scope language.downcase.to_sym, :conditions => { :language => abbr }
  end
end
