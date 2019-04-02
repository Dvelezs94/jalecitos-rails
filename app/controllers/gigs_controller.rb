class GigsController < ApplicationController
  include GigStatus
  include GetGig
  include PackTypes
  include SetLayout
  include ReportFunctions
  before_action :set_gig, only: [:destroy, :ban_gig]
  before_action :set_gig_with_first_pack, only: :toggle_status
  before_action :set_gig_with_all_asc, only: :show
  before_action :check_published, only: :show
  before_action :set_gig_create, only: [:create]
  before_action :set_gig_update, only: [:edit, :update]
  before_action :check_gig_ownership, only:[:edit, :update, :destroy, :toggle_status, :create]
  before_action :max_gigs, only: [:new, :create]
  before_action :check_running_orders, only: :destroy
  access user: { except: [:ban_gig] }, admin: [:ban_gig], all: [:show]
  layout :set_layout

  # GET /gigs/1
  def show
    if params[:reviews]
      get_reviews(true)
    elsif params[:related_gigs]
      get_related_gigs(true)
      render template: "shared/carousels/add_items_carousel.js.erb"
    else
      define_pack_names
      get_reviews
      get_related_gigs
      Searchkick.multi_search([@related_gigs, @reviews])
      report_options
    end
  end

  def ban_gig
    (@gig.published? || @gig.draft?) ? @gig.banned! : @gig.draft!
    redirect_to root_path, notice: "Gig status has been updated"
  end

  def toggle_status
    check_if_banned
    check_first_package
    if flash[:error]
      redirect_to user_path(current_user.slug)
    else
      change_status
      flash[:success] = "Se ha cambiado el estado del Jale exitosamente"
      redirect_to user_path(current_user.slug)
    end
  end

  # GET /gigs/new
  def new
    @gig = Gig.new
    prepare_packages
  end

  # GET /gigs/1/edit
  def edit
  end

  # POST /gigs
  def create
    if params[:gig_id].present? #editing in creation
      @success = @gig.update(gig_params)
      if !@success
        render :new
      end
    else #create
      @success = @gig.save
      if !@success
        render :new
      end
    end
    respond_to do |format|
      format.js {
        render "update_name"
       }
    end
  end

  # PATCH/PUT /gigs/1
  def update
    @success = @gig.update(gig_params)
    if @success
      # @package = Package.find_by_gig_id(@gig)
      respond_to do |format|
        format.js {
          render "update_name"
         }
      end
    else
      render :edit
    end
  end

  # DELETE /gigs/1
  def destroy
    @gig.destroy
    redirect_to user_path(current_user.slug), notice: 'El Jale fue destruido.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gig
      @gig = Gig.friendly.find(params[:id])
    end

    def set_gig_create
      if params[:gig_id].present? #edit in creation
        @gig = Gig.find(params[:gig_id])
      else #create
        @gig = Gig.new(gig_params)
      end
    end

    def set_gig_update
      if params[:gig_id].present? #after edit name in update, slug changes
        @gig = Gig.find(params[:gig_id])
      else #before changing name it can be finded by original name
        @gig = Gig.friendly.find(params[:id])
      end
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
      if current_user.gigs.count >= 20 && params[:gig_id].nil?
        flash[:error] = "Sólo puedes tener como máximo 20 Jales"
        redirect_to( my_account_users_path )
      end
    end

    def check_gig_ownership
        redirect_to(root_path, notice: "Este jale no te pertenece") if (current_user.nil? || current_user.id != @gig.user_id)
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
    ####################################
    def prepare_packages
      define_pack_names
      @new_packages =[]
      3.times do
        @new_packages << Package.new
      end
    end
end
