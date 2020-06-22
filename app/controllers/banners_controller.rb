class BannersController < ApplicationController
  layout "admin"
  before_action :set_banner, only: [:show, :edit, :update, :destroy]
  access admin: :all
  skip_before_action :verify_authenticity_token, only: [:create, :update]
  # GET /banners
  def index
    @banners = Banner.all
  end

  # GET /banners/1
  def show
  end

  # GET /banners/new
  def new
    @banner = Banner.new
  end

  # GET /banners/1/edit
  def edit
  end

  # POST /banners
  def create
    puts "X"*100
    params[:files].each do |file|
      puts file
      @banner = Banner.new(image: file) #order 0 by default
    end
  end

  # PATCH/PUT /banners/1
  def update
    if @banner.update(banner_params)
      redirect_to @banner, notice: 'Banner was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /banners/1
  def destroy
    @banner.destroy
    redirect_to banners_url, notice: 'Banner was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_banner
      @banner = Banner.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def banner_params
      params.require(:banner).permit(:image, :order)
    end
end
