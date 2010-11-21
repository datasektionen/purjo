class PostsController < ApplicationController
  require_role :editor, :except => [:show, :index]

  before_filter :process_category_list, :only => [:create, :update]
  before_filter :generate_written_by_options, :only => [:new, :edit, :create, :update]

  def index
    redirect_to '/'
  end
  
  def show
    @post = Post.find(params[:id])
    @noise = Noise.new(params[:noise])
  end

  def new
    @post = Post.new
    @post.draft = false
  end

  def edit
    @post = Post.find(params[:id])
    include_current_written_by
  end

  def create
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

    if @post.update_attributes(params[:post])
      flash[:notice] = 'Nyhet uppdaterad.'
    
      redirect_to(@post)
    else
      include_current_written_by
      render :action => "edit"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    return access_denied unless @post.editable?
    @post.destroy
    flash[:notice] = 'Nyhet borttagen.'
    
    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.xml  { head :ok }
    end
  end

  private

  def generate_written_by_options
    if Person.current.admin?
      @written_by_options = ChapterPost.all
    else
      @written_by_options = Person.current.functionaries.active.collect { |f|
        f.chapter_post
      }
    end
  end
  
  def include_current_written_by
    if @post && @post.written_by.present?
      @written_by_options.insert(0, @post.written_by).uniq! 
    end
  end

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
