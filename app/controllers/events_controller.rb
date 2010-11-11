class EventsController < InheritedResources::Base
  require_role :editor, :except => :show

  def new
    @event = Event.new
    now = DateTime.now.utc
    @event.starts_at = DateTime.new(now.year, now.month, now.day, now.hour, 0, 0)
    @event.ends_at = @event.starts_at + 1.hour

    if params[:post]
      @post = Post.find(params[:post])
      unless @post.nil?
        @event.name ||= @post.name
        @event.content ||= "*Relaterad nyhet:* \"#{@post.name}\":/nyheter/#{@post.id}" 
      end
    end
  end
  
  def create
    create! { calendar_path }
  end
  
  def update
    update! { calendar_path }
  end

  def destroy
    @event = Event.find(params[:id])
    return access_denied unless @event.editable?
    destroy! { calendar_path }
  end

end
