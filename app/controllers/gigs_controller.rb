class GigsController < ApplicationController
  layout 'gig'
  include SanitizeParams
  include GigStatus
  before_action :set_gig, only: [:show, :edit, :update, :destroy, :toggle_status, :ban_gig]
  before_action :check_gig_ownership, only:[:edit, :update, :destroy, :toggle_status]
  before_action :check_status, only:[:update]
  access user: {except: [:ban_gig]}, admin: [:ban_gig]

  # GET /gigs
  def index
    @gigs = Gig.where(user_id: current_user.id)
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
    @gig = Gig.new(sanitized_params(gig_params))

    if @gig.save
      redirect_to new_gig_package_path(@gig)
    else
      render :new
    end
  end

  # PATCH/PUT /gigs/1
  def update
    if @gig.update(sanitized_params(gig_params))
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
      gig_params = params.require(:gig).permit(:name,
                                  :description,
                                  :image,
                                  :location,
                                  :category_id
                                )
      gig_params = set_owner(gig_params)
    end

    def set_owner parameters
      parameters[:user_id] = current_user.id
      parameters
    end

    def check_gig_ownership
      if current_user.id != @gig.user_id
        redirect_to root_path
      end
    end

end
