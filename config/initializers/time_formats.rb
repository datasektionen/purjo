# Custom date formats
Time::DATE_FORMATS[:agenda] = lambda { |time| 
  if time.beginning_of_day == Time.now.beginning_of_day
    return "Idag"
  elsif time.beginning_of_day == (Time.now + 1.day).beginning_of_day
    return "Imorgon"
  else
    return time.strftime("%a %b %d")
  end
}
