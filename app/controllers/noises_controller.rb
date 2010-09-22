class NoisesController < ApplicationController
  def edit
    @noise = Noise.find(params[:id])
  end

  def create
    @post = Post.find(params[:post_id])
    @noise = @post.noises.new(params[:noise])
    
    @noise.person_id = Person.current.id
    
    if @noise.save
	    flash[:notice] = 'Kommentar skapad.'
    else
	    flash[:notice] = 'Kommentaren gick inte att skapa.'
    end
    redirect_to post_url(@noise.post_id)
  end

  def update
    @noise = Noise.find(params[:id])
    if @noise.editable?
      if @noise.update_attributes(params[:noise])
        flash[:notice] = 'Kommentar uppdaterad.'
      end
    else
	    flash[:notice] = 'Du får endast redigera dina egna kommentarer'
    end
    redirect_to post_url(@noise.post_id)
  end

  def destroy
    @noise = Noise.find(params[:id])
    if @noise.editable?
      @noise.destroy
    end

    redirect_to post_url(@noise.post_id)
  end
end
