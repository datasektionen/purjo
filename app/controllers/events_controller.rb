class EventsController < InheritedResources::Base
  require_role :editor, :except => :show

  def new
    @event = Event.new
    now = DateTime.now
    @event.starts_at = DateTime.new(now.year, now.month, now.day, now.hour, 0, 0)
    @event.ends_at = @event.starts_at + 1.hour
  end
  
  def create
    create! { calendar_path }
  end
  
  def update
    update! { calendar_path }
  end

  def destroy
    @event = Event.find(params[:id])
    raise AccessDenied unless Person.current.admin? || (Person.current.editor? && @event.created_by == Person.current)
    destroy! { calendar_path }
  end

end
