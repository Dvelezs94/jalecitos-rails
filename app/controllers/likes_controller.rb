class LikesController < ApplicationController
  access user: [:create, :destroy]
  before_action :authenticate_user!
  before_action :set_gig, only: [:create, :destroy]
  # before_action :check_like_ownership, only: [:destroy]

  # POST /likes
  def create
    @gig.likes.where(user: current_user).first_or_create

    respond_to do |format|
      format.html {
        flash[:notice] = "Se ha eliminado este Jale en tus favoritos"
        redirect_to the_gig_path(@gig)
      }
      format.js
    end
  end
  # DELETE /likes/1
  def destroy
    @gig.likes.where(user: current_user).destroy_all

    respond_to do |format|
      format.html {
        flash[:notice] = "Se ha eliminado este Jale en tus favoritos"
        redirect_to the_gig_path(@gig)
      }
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gig
      @gig = Gig.friendly.find(params[:gig_id])
    end
end
