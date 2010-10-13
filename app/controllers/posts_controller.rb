class PostsController < ApplicationController
  require_role :editor, :except => [:show, :index]
  require_role :admin, :only => [:destroy]

  def index
    redirect_to '/'
  end
  
  def show
    @post = Post.find(params[:id])
    @noise = Noise.new(params[:noise])
  end

  def new
    @post = Post.new

    @post.starts_at = DateTime.now
    @post.ends_at = DateTime.now + 1.hour
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    params[:post][:news_post] ||= "false"
    params[:post][:calendar_post] ||= "false"
    
    process_category_list

    @post = Post.new(params[:post])
    @post.created_by = Person.current
    
    if @post.save
      flash[:notice] = 'Nyhets-/kalenderinlägget skapat!'

      redirect_to(@post)
    else
      render :action => "new"
    end
  end

  def update
    params[:post][:news_post] ||= "false"
    params[:post][:calendar_post] ||= "false"
    
    @post = Post.find(params[:id])

    process_category_list

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

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    
    respond_to do |format|
      format.html { redirect_to(posts_url) }
      format.xml  { head :ok }
    end
  end

  private
  def process_category_list
    # Category/tag list generation
    return if !params.include?(:post)
    categories = ""
    categories << params[:post][:categories].join(',') unless params[:post][:categories].nil?
    params[:post].delete(:categories);
    if !params[:post][:categories_new].empty?
      categories << ',' + params[:post][:categories_new]
    end
    params[:post].delete(:categories_new)
    params[:post][:category_list] = categories
  end
end
