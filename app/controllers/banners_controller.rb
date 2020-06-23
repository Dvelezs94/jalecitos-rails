class BannersController < ApplicationController
  layout "admin"
  before_action :set_banner, only: [:show, :edit, :update, :destroy]
  access admin: :all
  skip_before_action :verify_authenticity_token, only: [:create, :update]
  # GET /banners
  def index
    @active_banners = Banner.where.not(display: 0).order(display: :asc)
    @inactive_banners = Banner.where(display: 0)
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

  def update_status
    Banner.all.update(active: params[:active])
  end

  # POST /banners
  def create
    params[:files].each do |file|
      banner = Banner.new(image: file) #order 0 by default
      @success = banner.save
    end
  end

  # PATCH/PUT /banners/1
  def update
    @banner.with_lock do
      old_display = @banner.display
      old_url = @banner.url
      if @banner.update(banner_params)
        flash[:success] = "Actualizado"
        #keep numeration in lowest numbers
        keep_numeration
      else
        flash[:error] = @banner.errors.full_messages.first
      end
      redirect_to(banners_path, notice: "Vista previa actualizada") if (@banner.display != old_display) || (old_url != @banner.url && @banner.display > 0)
    end
  end

  # DELETE /banners/1
  def destroy
    @banner.with_lock do
      @banner.destroy
      keep_numeration
      redirect_to banners_url, notice: 'Banner was successfully destroyed.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_banner
      @banner = Banner.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def banner_params
      par = params.require(:banner).permit(:display, :url)
    end
    def keep_numeration
      all = Banner.where.not(display: 0).order(display: :asc)
      x = 0
      while x < all.length
        if all[x].id == @banner.id && all[x-1].display == @banner.display #i updated banner before this, so if after the element that has same display, i have to check before banner
          all[x-1].update(display: x+1)
        elsif all[x].display != x+1
          all[x].update(display: x+1)
        end
        x+=1
      end
    end
end
