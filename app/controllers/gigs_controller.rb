class GigsController < ApplicationController
  include SanitizeParams
  include GigStatus
  include PackTypes
  include SetLayout
  include ReportFunctions
  before_action :set_gig, only: [:edit, :update, :destroy, :ban_gig]
  before_action :set_gig_with_first_pack, only: :toggle_status
  before_action :set_gig_with_all_asc, only: :show
  before_action :check_published, only: :show
  before_action :check_gig_ownership, only:[:edit, :update, :destroy, :toggle_status]
  before_action :max_gigs, only: [:new, :create]
  before_action :check_running_orders, only: :destroy
  access user: { except: [:ban_gig] }, admin: [:ban_gig], all: [:show]
  layout :set_layout

  # GET /gigs/1
  def show
    if params[:reviews]
      get_reviews
    elsif params[:related_gigs]
      get_related_gigs
      render template: "shared/carousels/add_items_carousel.js.erb"
    else
      define_pack_names
      get_reviews
      report_options
      get_related_gigs
    end
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
    redirect_to user_path(params[:user_id]), notice: 'El Jale fue destruido.'
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
      if @gig.draft? || @gig.banned?
        if !(current_user) || (! current_user.has_roles?(:admin) &&  @gig.user != current_user)
          redirect_to( user_path(@gig.user.slug), notice: "Este jale no está disponible" )
        end
      end
    end

    # Only allow a trusted parameter "white list" through.
    def gig_params
      gig_params = params.require(:gig).permit(:name,
                                  :description,
                                  :city_id,
                                  :category_id,
                                  :tag_list,
                                  :profession
                                ).merge(:user_id => current_user.id)

    end

    def max_gigs
      redirect_to( user_path(current_user.slug), notice: "Sólo puedes tener como máximo 20 Jales" ) if Gig.where(user_id: current_user.id).count > 19
    end

    def check_gig_ownership
      redirect_to(root_path) if (current_user.nil? || current_user.id != @gig.user_id)
    end

    def get_related_gigs
      @related_gigs = Gig.search("*", where: { category_id: @gig.category_id, status: "published", _id: { not: @gig.id }, city_id: @gig.city_id }, page: params[:related_gigs], per_page: 5)
    end

    def get_reviews
      #get the associated reviews that doesnt belong to gig owner
      @reviews = Review.search("*", where: { reviewable_id: @gig.id, reviewable_type: "Gig", receiver_id: @gig.user.id, status: "completed" }, order: [{ updated_at: { order: :desc, unmapped_type: :long}}], page: params[:reviews], per_page: 5)
    end

    # Check if there are running orders before destroying
    def check_running_orders
      order_count = 0
      packages = @gig.packages
      packages.each do |p|
        order_count += p.orders.where(status: "pending").or(p.orders.where(status: "in_progress")).or(p.orders.where(status: "disputed")).count
      end
      (order_count > 0) ? redirect_to(root_path, notice: "Tienes transacciones pendientes en este Jale") : true
    end

end
