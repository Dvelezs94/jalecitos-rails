class UsersController < ApplicationController
  respond_to :html, :json
  layout 'user'
  before_action :set_user, only: [:show, :update]
  access all: [:show, :index], user: [:show, :update]
  before_action :check_user_ownership, only:[:update]
  include UsersHelper

  # GET /users/1
  #al poner sitio/users da error, por eso esta ruta
  def index
    redirect_to root_path
  end

  def show
  end

  # PATCH/PUT /users/1
  def update
    flash[:notice] = 'Your profile was successfully updated.' if @user.update_attributes(user_params)
    respond_with(@user)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.friendly.find(params[:id])
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
        redirect_to root_path
      end
    end
end
