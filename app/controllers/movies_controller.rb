class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    if params[:sort_by]
      session[:sort_by] = params[:sort_by]
    end
    if params[:ratings]
      session[:ratings] = params[:ratings]
    end

    if (!params[:sort_by] && session[:sort_by]) || (!params[:ratings] && session[:ratings])
      flash.keep
      redirect_to movies_path(sort_by: session[:sort_by], ratings: session[:ratings])
    end

    if session[:ratings]
      conditions = ['rating IN (?)', session[:ratings].keys]
    else
      conditions = []
    end

    if session[:sort_by] == 'title' || session[:sort_by] == 'release_date'
        @movies = Movie.find(:all, :conditions => conditions, :order => session[:sort_by])
    else
        @movies = Movie.find(:all, :conditions => conditions)
    end

    @all_ratings = Movie.Ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
