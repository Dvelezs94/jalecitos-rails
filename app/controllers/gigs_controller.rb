class GigsController < ApplicationController
  include SanitizeParams
  include GigStatus
  include PackTypes
  include SetLayout
  before_action :set_gig, only: [:edit, :update, :destroy, :ban_gig]
  before_action :set_gig_with_first_pack, only: :toggle_status
  before_action :set_gig_with_all_asc, only: :show
  before_action :check_published, only: :show
  before_action :check_gig_ownership, only:[:edit, :update, :destroy, :toggle_status]
  before_action :max_gigs, only: [:new, :create]
  access user: { except: [:ban_gig] }, admin: [:ban_gig], all: [:show]
  layout :set_layout

  # GET /gigs/1
  def show
    define_pack_names
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
      redirect_to user_gig_galleries_path(current_user.slug, @gig)
    else
      render :new
    end
  end

  # PATCH/PUT /gigs/1
  def update
    if @gig.update(sanitized_params(gig_params))
      @package = Package.find_by_gig_id(@gig)
      redirect_to user_gig_galleries_path(current_user.slug, @gig)
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

    def check_published
      ( @gig.user != current_user && (@gig.draft? || @gig.banned? ) )? redirect_to( user_path(@gig.user.slug), notice: "Este jale no está disponible" ) : nil
    end

    # Only allow a trusted parameter "white list" through.
    def gig_params
      gig_params = params.require(:gig).permit(:name,
                                  :description,
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

    def max_gigs
      (Gig.where(user_id: current_user.id).count > 19)? redirect_to( user_path(current_user.slug), notice: "Sólo puedes tener como máximo 20 Jales" ) : nil
    end

    def check_gig_ownership
      (current_user.nil? || current_user.id != @gig.user_id) ? redirect_to(root_path) : nil
    end

end
