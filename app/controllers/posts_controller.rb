class PostsController < ApplicationController
  require_role :editor, :except => [:show, :index]
  require_role :admin, :only => [:destroy]
  
  # GET /posts/1
  def show
    @post = Post.find(params[:id])
    @noise = Noise.new(params[:noise])
  end

  # GET /posts/new
  def new
    @post = Post.new

    @post.starts_at = DateTime.now
    @post.ends_at = DateTime.now + 1.hour
  end

  # GET /posts/1/edit
  def edit
    @post = Post.find(params[:id])
  end

  # POST /posts
  def create
    params[:post][:news_post] ||= "false"
    params[:post][:calendar_post] ||= "false"
    
    @post = Post.new(params[:post])
    @post.created_by = Person.current
    
    if @post.save
      flash[:notice] = 'Nyhets-/kalenderinlägget skapat!'

      redirect_to(@post)
    else
      render :action => "new"
    end
  end

  # PUT /posts/1
  def update
    params[:post][:news_post] ||= "false"
    params[:post][:calendar_post] ||= "false"
    
    @post = Post.find(params[:id])

    if @post.update_attributes(params[:post])
      flash[:notice] = 'Nyhets-/kalenderinlägget uppdaterat.'
    
      if @post.calendar_post
        redirect_to calendar_path
      else
        redirect_to root_path
      end
    else
      render :action => "edit"
    end
  end

  # DELETE /posts/1
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    
    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end
end
