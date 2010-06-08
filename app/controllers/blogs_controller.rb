class BlogsController < ApplicationController
  require_role :admin, :except => [:show]
  
  # GET /blogs
  def index
    @blogs = Blog.find(:all)

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  # GET /blogs/1
  def show
    @blog = Blog.find_by_perma_name(params[:id])
    redirect_to blog_articles_path(@blog)
  end

  # GET /blogs/new
  def new
    @blog = Blog.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /blogs/1/edit
  def edit
    @blog = Blog.find_by_perma_name(params[:id])
  end

  # POST /blogs
  def create
    @blog = Blog.new(params[:blog])

    respond_to do |format|
      if @blog.save
        flash[:notice] = 'Blog was successfully created.'
        format.html { redirect_to(blog_path(@blog)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /blogs/1
  def update
    @blog = Blog.find_by_perma_name(params[:id])

    respond_to do |format|
      if @blog.update_attributes(params[:blog])
        flash[:notice] = 'Blog was successfully updated.'
        format.html { redirect_to(blog_path(@blog)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /blogs/1
  def destroy
    @blog = Blog.find_by_perma_name(params[:id])
    @blog.destroy

    respond_to do |format|
      format.html { redirect_to(blogs_path) }
    end
  end
  
end
