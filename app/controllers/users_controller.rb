class UsersController < ApplicationController
  include OpenpayHelper
  include UsersHelper
  respond_to :html, :json
  layout 'logged'
  before_action :set_user, only: [:show, :update]
  before_action :set_user_config, only: [:configuration]
  access all: [:show, :index], user: [:update, :configuration]
  before_action :check_user_ownership, only:[:update, :configuration]



  # GET /users/1
  #al poner sitio/users da error, por eso esta ruta
  def index
    redirect_to root_path
  end

  def configuration
    @openpay_id = @user.openpay_id
    @user_banks = get_openpay_resource("bank", @openpay_id)
    @user_cards = get_openpay_resource("card", @openpay_id)
  end

  def show
    @gigs = Gig.includes(:packages, :user).where(user_id: @user)
    @requests = @user.gigs
  end

  # PATCH/PUT /users/1
  def update
    flash[:success] = 'Your profile was successfully updated.' if @user.update_attributes(user_params)
    respond_with(@user)
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
                                   :bio)
    end
    def check_user_ownership
      if ! my_profile
        flash[:error] = "No tienes permisos para acceder aqui"
        redirect_to root_path
      end
    end
end
