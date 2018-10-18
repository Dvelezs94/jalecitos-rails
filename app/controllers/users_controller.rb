class UsersController < ApplicationController
  respond_to :html, :json
  layout 'user'
  before_action :set_user, only: [:show, :edit, :update]
  access all: [:show], user: [:show, :edit, :update]
  before_action :check_user_ownership, only:[:update, :destroy]
  include UsersHelper

  # GET /users/1
  def show
  end

  # GET /users/1/edit
  def edit
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
