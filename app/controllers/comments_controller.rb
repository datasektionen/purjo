class CommentsController < ApplicationController
  before_filter :load_commentable
  
  def index
    @comments = @commentable.comments
  end
  
  def create
    @comment = @commentable.comments.build(params[:comment])
    
    if @comment.save
      flash[:notice] = "Kommentar sparad!"
      redirect_to event_path(@commentable)
    else
      flash[:error] = "Ett fel uppstod vid sparande av kommentar"
      @event = @commentable
      render :template => 'events/show'
    end
  end
  
  def load_commentable
    @commentable = Event.find(params[:event_id])
  end
end
