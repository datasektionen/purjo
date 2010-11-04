class PostsController < ApplicationController
  require_role :editor, :except => [:show, :index]

  def index
    redirect_to '/'
  end
  
  def show
    @post = Post.find(params[:id])
    @noise = Noise.new(params[:noise])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
  end

  def create
    process_category_list

    @post = Post.new(params[:post])
    @post.created_by = Person.current
    
    if @post.save
      flash[:notice] = 'Nyhet skapad!'

      redirect_to(@post)
    else
      render :action => "new"
    end
  end

  def update
    @post = Post.find(params[:id])

    process_category_list

    if @post.update_attributes(params[:post])
      flash[:notice] = 'Nyhet uppdaterad.'
    
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
    raise AccessDenied unless Person.current.admin? || (Person.current.editor? && @post.created_by == Person.current)
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
