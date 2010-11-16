class ChapterPostsController < ApplicationController

  layout 'application'
  require_role "editor", :except => [:show]

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

  def show
    @menu_template = "sektionen"
    @chapter_post = ChapterPost.find_by_slug(params[:id])
    @chapter_post = ChapterPost.find(params[:id]) if @chapter_post.nil?
    raise IOR::Security::AccessDenied if @chapter_post.nil?
  end

  def new
    @chapter_post = ChapterPost.new
  end

  def edit
    @chapter_post = ChapterPost.find_by_slug(params[:id])
  end

  def create
    @chapter_post = ChapterPost.new(params[:chapter_post])

    respond_to do |format|
      if @chapter_post.save
        flash[:notice] = 'Funktionärsposten är skapad.'
        format.html { redirect_to(@chapter_post) }
        format.xml  { render :xml => @chapter_post, :status => :created, :location => @chapter_post }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @chapter_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @chapter_post = ChapterPost.find_by_slug(params[:id])

    respond_to do |format|
      if @chapter_post.update_attributes(params[:chapter_post])
        flash[:notice] = 'Funktionärsposten är uppdaterad.'
        format.html { redirect_to(@chapter_post) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @chapter_post.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @chapter_post = ChapterPost.find_by_slug(params[:id])
    @chapter_post.destroy

    respond_to do |format|
      format.html { redirect_to(chapter_posts_url) }
      format.xml  { head :ok }
    end
  end
end
