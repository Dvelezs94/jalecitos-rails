class GigsController < ApplicationController
  layout 'gig'
  include SanitizeParams
  include GigStatus
  before_action :set_gig, only: [:edit, :update, :destroy, :ban_gig]
  before_action :set_gig_with_first_pack, only: :toggle_status
  before_action :set_gig_with_all_asc, only: :show
  before_action :check_gig_ownership, only:[:edit, :update, :destroy, :toggle_status]
  access user: { except: [:ban_gig] }, admin: [:ban_gig]

  # GET /gigs/1
  def show
    @show_packages = true
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
      redirect_to new_user_gig_package_path(params[:user_id],@gig)
    else
      render :new
    end
  end

  # PATCH/PUT /gigs/1
  def update
    if @gig.update(sanitized_params(gig_params))
      @package = Package.find_by_gig_id(@gig)
      redirect_to edit_user_gig_packages_path(params[:user_id], @gig )
    else
      render :edit
    end
  end

  # DELETE /gigs/1
  def destroy
    @gig.destroy
    redirect_to user_path(params[:user_id]), notice: 'Gig was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gig
      @gig = Gig.friendly.find(params[:id])
    end

    def set_gig_with_first_pack
      @gig = Gig.includes(:gig_first_pack).friendly.find(params[:id])
    end

    def set_gig_with_all_asc
      @gig = Gig.includes(:gig_packages, :category, :user).friendly.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def gig_params
      gig_params = params.require(:gig).permit(:name,
                                  :description,
                                  :image,
                                  :location,
                                  :category_id,
                                  :tag_list
                                )
      gig_params = set_owner(gig_params)
    end

    def set_owner parameters
      parameters[:user_id] = current_user.id
      parameters
    end

    def check_gig_ownership
      (current_user.nil? || current_user.id != @gig.user_id) ? redirect_to(root_path) : nil
    end

end
