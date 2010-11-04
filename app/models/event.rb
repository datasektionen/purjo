class Event < ActiveRecord::Base
  scope :for_month, lambda { |month, year|
    date = DateTime.civil(year, month)
    
    {:conditions => [ 'NOT (ends_at < :start_date OR starts_at > :end_date)', {:start_date => date, :end_date => date.end_of_month}]}
  }
  
  scope :for_day, lambda {|day, month, year|
    date = DateTime.civil(year, month, day)
    
    {:conditions => [ 'NOT (ends_at < :start_date OR starts_at > :end_date)', {:start_date => date.beginning_of_day, :end_date => date.end_of_day}]}
  }
  
  scope :between, lambda { |from, to|
    where(:starts_at.gt => from, :ends_at.lt => to)
  }
  
  scope :newer_than, lambda { |time| where(['starts_at > ?', Time.now - time]) }
  
  belongs_to :created_by, :class_name => 'Person'
  validates_presence_of :starts_at, :ends_at
  validate :start_date_before_end_date

  private
  
  def start_date_before_end_date
    return unless starts_at.present? && ends_at.present?
    
    if self.starts_at > self.ends_at
      errors.add_to_base "Aktiviteten måste börja innan den slutar, doh!"
    end
  end
  
end
