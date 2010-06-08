class CalendarPost < ActiveRecord::Base
  belongs_to :post_content
  
  named_scope :for_month, lambda { |month, year|
    date = DateTime.civil(year, month)
    {:conditions => [ 'NOT (ends_at < :date OR starts_at > :end_date)', {:date => date, :end_date => date.end_of_month}]}
  }
  
  def self.tagged_with(tags)
    tags = tags.split(',')
    
    PostContent.tagged_with(tags, :on => :categories).find_all{|pc| pc.calendar_post}.map{|pc| pc.calendar_post}
  end
end
