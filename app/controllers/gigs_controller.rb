class GigsController < ApplicationController
  before_action :set_gig, only: [:show, :edit, :update, :destroy]
  before_action :check_gig_ownership, only:[:edit, :update, :destroy]
  before_action :set_google_scripts, only: [:new, :edit ]
  access all: [:index, :show], user: :all

  # GET /gigs
  def index
    @gigs = Gig.where("user_id = #{current_user.id}")
  end

  # GET /gigs/1
  def show
  end

  # GET /gigs/new
  def new
    @gig = Gig.new
  end

  # GET /gigs/1/edit
  def edit
  end

  # POST /gigs
  def create
    @gig = Gig.new(params_with_user)

    if @gig.save
      redirect_to @gig, notice: 'Gig was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /gigs/1
  def update
    if @gig.update(gig_params)
      redirect_to @gig, notice: 'Gig was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /gigs/1
  def destroy
    @gig.destroy
    redirect_to gigs_url, notice: 'Gig was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gig
      @gig = Gig.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def gig_params
      params.require(:gig).permit(:name, :description, :image, :location, :user_id, :category_id, :tag_id)
    end

    def params_with_user
      params_with_user = gig_params
      params_with_user['user_id'] = current_user.id
      params_with_user
    end

    def check_gig_ownership
      if current_user.id != @gig.user_id
        redirect_to root_path
      end
    end
    def set_google_scripts
      @set_google_javascript = ''
    end

end
