class ElectionEvent < ActiveRecord::Base

  scope :active, lambda { where("date >= ?", DateTime.now - 1.day) }
  scope :ordered, order("date asc")

  has_many :nominees

  def formated
    "#{name} (#{date})"
  end

end
