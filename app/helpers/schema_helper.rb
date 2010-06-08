module SchemaHelper
  
  def diff_columns(column, last_columns)
    return column.first.start.hour - 8 if last_columns.nil?
    return column.first.start.hour - last_columns.last.last.stop.hour
  end
  
  def diff_events(event, last_event)
    return 0 if last_event.nil?
    return event.start.hour - last_event.stop.hour
  end
  
end
