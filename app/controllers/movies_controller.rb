class MoviesController < ApplicationController
  def index
	  @movies = Movie.order('movies.title ASC').all
    #@movies = Movie.all.sort_by {|obj| obj.title}
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    render(:partial => 'movie', :object => @movie) if request.xhr?
    # will render app/views/movies/show.html.haml by default
  end

  def new
    # default: render ’new’ template
  end

  def create
    user_params = params.require(:movie).permit(:title,:rating,:release_date,:description)
    @movie = Movie.create!(user_params)
    flash[:notice] = "#{@movie.title} was successfully created." 
    redirect_to movie_path(@movie)
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    permitted = params[:movie].permit(:title,:rating,:release_date)
    @movie.update!(permitted)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
    # Using a private method to encapsulate the permissible parameters is just a good pattern
    # since you'll be able to reuse the same permit list between create and update. Also, you
    # can specialize this method with per-user checking of permissible attributes.
    def movie_params
      params.require(:movie).permit(:title, :rating, :description, :release_date)
    end
end
 
