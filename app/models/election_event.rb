class ElectionEvent < ActiveRecord::Base

  scope :active, lambda { where("date >= ?", DateTime.now - 1.day) }
  scope :ordered, order("date asc")

  def formated
    "#{name} (#{date})"
  end

end
