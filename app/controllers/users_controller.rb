class UsersController < ApplicationController
  include OpenpayHelper
  include SetLayout
  include UsersHelper
  include ReportFunctions
  respond_to :html, :json
  layout :set_layout
  before_action :set_user, only: [:show, :update]
  before_action :set_user_config, only: [:configuration]
  access all: [:show, :index], user: [:update, :configuration]


  def configuration
      @openpay_id = @user.openpay_id
      @user_banks = get_openpay_resource("bank", @openpay_id)
      @user_cards = get_openpay_resource("card", @openpay_id)
      @roles = {:employee => "Vendedor", :employer => "Comprador"}
      @billing_profiles = current_user.billing_profiles.enabled
      @billing_profile = BillingProfile.new
    end

  def show
    if params[:reviews]
      @reviews = Review.search("*", where: {receiver_id: @user.id, status: "completed"}, order: [{ created_at: { order: :desc, unmapped_type: :long}}], page: params[:reviews], per_page: 20)
    elsif params[:requests]
      @requests = Request.search("*", where: {user_id: @user.id}, order: [{ updated_at: { order: :desc, unmapped_type: :long}}], page: params[:requests], per_page: 20 )
    else
      report_options
      @reviews = Review.search("*", where: {receiver_id: @user.id, status: "completed"}, order: [{ created_at: { order: :desc, unmapped_type: :long}}], page: params[:reviews], per_page: 20)
      if @user == current_user
        @gigs = Gig.search("*", includes: [:packages, :user], where: {user_id: @user.id}, order: [{ updated_at: { order: :desc, unmapped_type: :long}}], execute: false )
        @requests = Request.search("*", where: {user_id: @user.id}, order: [{ updated_at: { order: :desc, unmapped_type: :long}}], execute: false, page: params[:requests], per_page: 20 )
        Searchkick.multi_search([@gigs, @requests])
      else
        @gigs = Gig.search("*", includes: [:packages, :user], where: {user_id: @user.id, status: "published"} )
      end
    end
  end

  # PATCH/PUT /users/1
  def update
    # best in place update roles based on list select
    if @role = params[:user]["roles"]
      case @role
        when "employee"
          @user.update_attributes(:roles => [:user, :employee])
        when "employer"
          @user.update_attributes(:roles => [:user, :employer], tags: [])
          @user.gigs.published.each do |g|
            g.draft!
        end
        when "employee_employer"
          @user.update_attributes(:roles => [:user, :employer, :employee])
      end
    # best in place for tags, split them to make a list and grab the first 10
    elsif params[:user]["tag_list"]
      @tag_list = params[:user]["tag_list"].downcase.split(" ")
      # @user.tag_list = @tag_list.first(10)
      # @user.save
      @user.update_attributes(:tag_list => @tag_list.first(10))
    elsif params[:user][:city_id]
      @user.update(city_id: params[:user][:city_id])
    # else we save the parameters as they come since they dont need special treatment
    else
      @user.update_attributes(user_params)
    end

    respond_to do |format|
      if params[:user]["alias"]
        # flash[:success] = 'Tu alias ha sido actualizado.'
        format.json  { render :json => { :redirect => configuration_path } }
      else
        format.json { respond_with_bip(@user) }
        #changing location use this
        format.html { redirect_to request.referrer }
      end
    end

  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.friendly.find(params[:id])
    end

    def set_user_config
      @user = current_user
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name,
                                   :alias,
                                   :image,
                                   :bio,
                                   :age,
                                   :available,
                                   :location,
                                   :roles,
                                   :tag_list,
                                   :transactional_emails,
                                   :marketing_emails)
    end
end
