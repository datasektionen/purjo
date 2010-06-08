class ArticlesController < ApplicationController
  before_filter :load_blog
  
  require_role :editor, :except => [:show, :index]
  
  # GET /articles
  def index
    @articles = @blog.articles

    respond_to do |format|
      format.html { render :layout => layout_for(@blog)} # index.html.erb
      format.rss
    end
  end

  # GET /articles/1
  def show
    @article = @blog.articles.find(params[:id])

    respond_to do |format|
      format.html { render :layout => layout_for(@blog)} # show.html.erb
    end
  end

  # GET /articles/new
  def new
    @article = @blog.articles.new

    respond_to do |format|
      format.html { render :layout => layout_for(@blog)} # new.html.erb
    end
  end

  # GET /articles/1/edit
  def edit
    @article = @blog.articles.find(params[:id])

    respond_to do |format|
       format.html { render :layout => layout_for(@blog)}
     end
  end

  # POST /articles
  def create
    @article = @blog.articles.new(params[:article].merge(:author => Person.current))

    respond_to do |format|
      if @article.save
        flash[:notice] = 'Article was successfully created.'
        format.html { redirect_to(blog_article_path(@blog, @article)) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /articles/1
  def update
    @article = @blog.articles.find(params[:id])

    respond_to do |format|
      if @article.update_attributes(params[:article])
        flash[:notice] = 'Article was successfully updated.'
        format.html { redirect_to(blog_article_path(@blog, @article)) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /articles/1
  def destroy
    @article = @blog.articles.find(params[:id])
    @article.destroy

    respond_to do |format|
      format.html { redirect_to(blog_articles_path(@blog)) }
    end
  end
  
  protected
  
  def layout_for(blog)
    blog.layout.blank? ? nil : blog.layout
  end
  
  def load_blog
    @blog = Blog.find_by_perma_name(params[:blog_id])
  end
end
