class ElectionEvent < ActiveRecord::Base

  def formated
    "#{name} (#{date})"
  end

end
