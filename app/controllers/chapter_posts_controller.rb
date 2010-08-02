class ChapterPostsController < ApplicationController

  layout 'application'
  require_role "editor", :except => [:show]

  # GET /chapter_posts
  # GET /chapter_posts.xml
  def index
    if params[:user]
      @chapter_posts = ChapterPost.new
      @chapter_posts = @chapter_posts.find_chapter_posts_by_kth_username(params[:user])
      if !@chapter_posts.is_a?(Array)
        render :text => h([ @chapter_posts ].inspect)
      end
    else
      @chapter_posts = ChapterPost.find(:all, :order => "name")
    end
  end

  # GET /chapter_posts/1
  # GET /chapter_posts/1.xml
  def show
    @chapter_post = ChapterPost.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @chapter_post }
    end
  end

  # GET /chapter_posts/new
  # GET /chapter_posts/new.xml
  def new
    @chapter_post = ChapterPost.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @chapter_post }
    end
  end

  # GET /chapter_posts/1/edit
  def edit
    @chapter_post = ChapterPost.find(params[:id])
  end

  # POST /chapter_posts
  # POST /chapter_posts.xml
  def create
    @chapter_post = ChapterPost.new(params[:chapter_post])

    respond_to do |format|
      if @chapter_post.save
        flash[:notice] = 'ChapterPost was successfully created.'
        format.html { redirect_to(@chapter_post) }
        format.xml  { render :xml => @chapter_post, :status => :created, :location => @chapter_post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @chapter_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /chapter_posts/1
  # PUT /chapter_posts/1.xml
  def update
    @chapter_post = ChapterPost.find(params[:id])

    respond_to do |format|
      if @chapter_post.update_attributes(params[:chapter_post])
        flash[:notice] = 'ChapterPost was successfully updated.'
        format.html { redirect_to(@chapter_post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @chapter_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /chapter_posts/1
  # DELETE /chapter_posts/1.xml
  def destroy
    @chapter_post = ChapterPost.find(params[:id])
    @chapter_post.destroy

    respond_to do |format|
      format.html { redirect_to(chapter_posts_url) }
      format.xml  { head :ok }
    end
  end
end
