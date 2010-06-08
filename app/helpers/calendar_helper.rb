module CalendarHelper
  def previous_month_link(month, year)
    if month == 1
      month = 12
      year -= 1
    else
      month -= 1
    end
    link_to "#{Ior::CalendarHelper::MONTH_NAMES[month]} #{year}", calendar_path(:month => month, :year => year)
  end
  
  def next_month_link(month, year)
    if month == 12
      month = 1
      year += 1
    else
      month += 1
    end
    link_to "#{Ior::CalendarHelper::MONTH_NAMES[month]} #{year}", calendar_path(:month => month, :year => year)
  end
  
end
