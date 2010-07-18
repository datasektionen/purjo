module CalendarHelper
  MONTH_NAMES = ["", "Januari", "Februari", "Mars", "April", "Maj", "Juni", "Juli", "Augusti", "September", "Oktober", "November", "December"]

  def get_month_name(month)
    return MONTH_NAMES[month]
  end

  def previous_month_link(month, year)
    if month == 1
      month = 12
      year -= 1
    else
      month -= 1
    end
    link_to "#{MONTH_NAMES[month]} #{year}", calendar_path(:month => month, :year => year)
  end
  
  def next_month_link(month, year)
    if month == 12
      month = 1
      year += 1
    else
      month += 1
    end
    link_to "#{MONTH_NAMES[month]} #{year}", calendar_path(:month => month, :year => year)
  end
  
end
