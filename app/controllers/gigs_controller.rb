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
  before_action :check_running_orders, only: :destroy
  access user: { except: [:ban_gig] }, admin: [:ban_gig], all: [:show]
  layout :set_layout

  # GET /gigs/1
  def show
    define_pack_names
    get_reviews
    report_options
    @related_gigs = Gig.search("*", where: { category_id: @gig.category_id }, limit: 5)
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
                                  :location,
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

    def report_options
      @report_options = ["Uso de palabras ofensivas", "Contenido Sexual", "Violencia", "Spam", "Engaño o fraude", "Otro"]
    end

    def get_reviews
      #get the associated reviews that doesnt belong to gig owner
      @reviews = Review.search("*", where: { reviewable_id: @gig.id, reviewable_type: "Gig", giver_id: {not: @gig.user.id}, status: "completed" }, order: [{ created_at: { order: :desc, unmapped_type: :long}}])
      #select only the rated reviews (the review can be completed with rating score of 0, so be careful)
      @reviews = @reviews.select{|r| r.rating.present? && r.rating.stars.between?(1,5)}
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
