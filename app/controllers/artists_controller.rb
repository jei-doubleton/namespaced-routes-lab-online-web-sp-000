class ArtistsController < ApplicationController
  before_action :set_preferences, only: [:index, :new]

  def index
    if @preference && @preference.artist_sort_order
      @artists = Artist.order(name: @preference.artist_sort_order)
    else
      @artists = Artist.all 
    end
  end

  def show
    @artist = Artist.find(params[:id])
  end

  def new
    if @preference && !@preference.allow_create_artists
      redirect_to artists_path
    else
      @artist = Artist.new
    end
  end

  def create
    @artist = Artist.new(artist_params)

    if @artist.save
      redirect_to @artist
    else
      render :new
    end
  end

  def edit
    @artist = Artist.find(params[:id])
  end

  def update
    @artist = Artist.find(params[:id])

    @artist.update(artist_params)

    if @artist.save
      redirect_to @artist
    else
      render :edit
    end
  end

  def destroy
    @artist = Artist.find(params[:id])
    @artist.destroy
    flash[:notice] = "Artist deleted."
    redirect_to artists_path
  end

  private

  def artist_params
    params.require(:artist).permit(:name)
  end

  def set_preferences
    @preference = Preference.last
  end
end
