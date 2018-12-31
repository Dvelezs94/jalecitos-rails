class UsersController < ApplicationController
  include OpenpayHelper
  include SetLayout
  include UsersHelper
  respond_to :html, :json
  layout :set_layout
  before_action :set_user, only: [:show, :update]
  before_action :set_user_config, only: [:configuration]
  access all: [:show, :index], user: [:update, :configuration]
  before_action :check_user_ownership, only:[:update, :configuration]


  def configuration
      @openpay_id = @user.openpay_id
      @user_banks = get_openpay_resource("bank", @openpay_id)
      @user_cards = get_openpay_resource("card", @openpay_id)
      @roles = {:employee => "Vendedor", :employer => "Comprador"}
    end

  def show
    if @user == current_user
      @gigs = Gig.includes(:packages, :user).where(user_id: @user)
      @requests = Request.includes(:user).where(user_id: @user)
    else
      @gigs = Gig.includes(:packages, :user).published.where(user_id: @user)
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
    # else we save the parameters as they come since they dont need special treatment
    else
      @user.update_attributes(user_params)
    end
    #flash[:success] = 'Your profile was successfully updated.'
    respond_to do |format|
        format.json { respond_with_bip(@user) }
    end
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.friendly.find(params[:id])
    end

    def set_user_config
      @user = User.friendly.find(params[:user_id])
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
                                   :tag_list)
    end
    def check_user_ownership
      if ! my_profile
        flash[:error] = "No tienes permisos para acceder aqui"
        redirect_to root_path
      end
    end
end
