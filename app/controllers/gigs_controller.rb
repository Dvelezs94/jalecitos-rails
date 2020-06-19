class GigsController < ApplicationController
  include GigStatus
  include GetGig
  include SearchFunctions
  include PackTypes
  include SetLayout
  include BannedFunctions
  access user: { except: [:ban_gig] }, admin: [:ban_gig], all: [:show, :old_show]
  before_action :set_gig, only: [:destroy, :ban_gig, :mail_contact]
  before_action :set_gig_with_first_pack, only: :toggle_status
  before_action :set_gig_with_all_asc, only: [:show, :old_show]
  before_action :remember_review, only: [:show]
  before_action :check_published, only: [:show, :old_show]
  before_action :redirect_to_show, only: [:old_show]
  before_action :set_gig_create, only: [:create]
  before_action :set_gig_edit, only: [:edit]
  before_action :set_gig_update, only: [:update]
  before_action :check_gig_ownership, only:[:edit, :update, :destroy, :toggle_status, :create]
  before_action :max_gigs, only: [:new, :create]
  before_action :check_running_orders, only: :destroy
  layout :set_layout

  def old_show
    #redirecting in redirect_to_show
  end
  # GET /gigs/1
  def show
    if params[:reviews]
      get_reviews
    else
      define_pack_names
      get_my_reviews if current_user && @gig.user != current_user
      get_reviews
      get_related_gigs
      Searchkick.multi_search([@related_gigs])
    end
    # increment gig visit
    punch_gig if current_user != @gig.user
  end

  def ban_gig
    (@gig.published? || @gig.draft?) ? @gig.banned! : @gig.draft!
    redirect_to root_path, notice: "Gig status has been updated"
  end

  def mail_contact
    if params[:message].present? && params[:email].present? && params[:name].present? && params[:phone_number].present?
      ContactMailer.new_message(params[:message], params[:email], params[:name], params[:phone_number], @gig.user.email).deliver
    end
  end

  def toggle_status
    flash_if_gig_banned
    flash_if_user_banned
    flash_if_first_package
    if flash[:error]
      redirect_to the_gig_path(@gig)
    else
      change_status
      flash[:success] = "Estado actual del Jale: #{t("gigs.status.#{@gig.status}")}"
      redirect_to the_gig_path(@gig)
    end
  end

  # GET /gigs/new
  def new
    @gig = Gig.new
    prepare_packages
  end

  # GET /gigs/1/edit
  def edit
    if @gig.gig_packages.none?
      prepare_packages
    end

  end

  # POST /gigs
  def create
    @gig.with_lock do
      @faqs_hash = params.require(:gig).permit(faqs_attributes: [:id, :question, :answer, :_destroy])["faqs_attributes"]
      cocoon_prevent_more_than_5_faqs if @faqs_hash.present?
      if params[:gig_id].present? #editing in creation
        @gig.faqs.delete_all #in create cocoon just saves faqs, so i have to delete old ones in case they save more than 1 time
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
  end

  # PATCH/PUT /gigs/1
  def update
    @gig.with_lock do
      @faqs_hash = params.require(:gig).permit(faqs_attributes: [:id, :question, :answer, :_destroy])["faqs_attributes"]
      cocoon_prevent_more_than_5_faqs if @faqs_hash.present?
      @success = @gig.update(gig_params)
      if @success
        fix_cocoon_multi_record if @faqs_hash.present?
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
  end

  # DELETE /gigs/1
  def destroy
    @gig.with_lock do
      @gig.destroy
      redirect_to user_path(current_user.slug), notice: 'El Jale fue destruido.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def redirect_to_show
      redirect_to the_gig_path @gig
    end
    def set_gig
      @gig = Gig.friendly.find(params[:id])
    end
    # increment visits
    def punch_gig
      # if cookies are disabled, return true and nothing else
      return true if request.cookies.blank?
      if cookies[:visits_time].present? && cookies[:gig_visits].present?
        array = JSON.parse(cookies.permanent[:gig_visits])
        if ! cookies[:visits_time]
          @gig.punch(request)
          cookies[:visits_time] = {value: 30.minutes.from_now.to_s, expires: 30.minutes.from_now}
          cookies.permanent[:gig_visits] = array.push(@gig.id).to_s
        elsif ! array.include?(@gig.id)
          @gig.punch(request)
          cookies.permanent[:gig_visits] = array.push(@gig.id).to_s
        end
      else
        cookies[:visits_time] = {value: 30.minutes.from_now.to_s, expires: 30.minutes.from_now}
        cookies.permanent[:gig_visits] = "[#{@gig.id}]"
        @gig.punch(request)
      end
    end

    def set_gig_create
      if params[:gig_id].present? #edit in creation
        @gig = Gig.find(params[:gig_id])
      else #create
        @gig = Gig.new(gig_params)
      end
    end

    def set_gig_update
      if params[:gig_id].present? #after edit name in update, slug changes (not anymore)
        @gig = Gig.find(params[:gig_id])
      else #before changing name it can be finded by original name
        @gig = Gig.friendly.find(params[:id])
      end
    end

    def set_gig_edit
      @gig = Gig.includes(:gig_packages, :faqs, :category, :tags).friendly.find(params[:id])
    end



    def set_gig_with_first_pack
      @gig = Gig.includes(:gig_packages).friendly.find(params[:id])
    end

    def set_gig_with_all_asc
      @gig = Gig.includes(:gig_packages, :category, :faqs, :tags,:likes,:user => [:score]).friendly.find(params[:id])
      @gig_hits = @gig.visits
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
                                  :address_name,
                                  :lat,
                                  :youtube_url,
                                  :lng,
                                  :category_id,
                                  :tag_list,
                                  :profession,
                                  faqs_attributes: [:id, :question, :answer, :_destroy]
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

    #fix cocoon new add bug
    def cocoon_prevent_more_than_5_faqs
      @still_in_view =[]
      @all_except_deleted = 0
      @will_be_created = 0
      @faqs_hash.each do |key, value|
        @still_in_view << value["id"] if key.to_i < 5 && value["_destroy"] == "false" #the faqs i passed to the view initially have simple numbers, if destroy is false, then they re still there
        @all_except_deleted+=1 if value["_destroy"] != "1"
        @will_be_created+=1 if !value.key?(:id)
      end
      head(:no_content) if @will_be_created > 5 #prevent trying to hack questions
      #the other variables @still_in_view and @all_except_deleted are just useful in update
    end

    def fix_cocoon_multi_record #in worst case, user gives me 10 new records (a hacker), this code will prevent to just have at max 10 faqs
      new_records = 0
      need_to_erase = @gig.faqs.length - @all_except_deleted
      new_faqs = @gig.faqs.where.not(id: @still_in_view).order(created_at: :asc) #i dont care about the faqs of view that are still there
      if need_to_erase > 0
          new_faqs[0..need_to_erase-1].each do |faq|
            faq.destroy
          end
      end
    end
    ####################################
    def prepare_packages
      define_pack_names
      @new_packages =[]
      3.times do
        @new_packages << Package.new
      end
    end

    def remember_review #if you want to shw message in other page, this code has to be executed in that page
      @max_score_times = 5
      if current_user && current_user == @gig.user && @gig.score_times < 5 && @gig.published? && !cookies[:remember_review]
        cookies[:remember_review] = {
          expires: (ENV.fetch("RAILS_ENV") == "production")? 3.day: 10.second #time that elapses to show message again
        }
        @remember_review = true
      end
    end
end
