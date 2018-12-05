class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_gig, only: [:create, :destroy]
  # before_action :check_like_ownership, only: [:destroy]
  access user: [:create, :destroy]

  # POST /likes
  def create
    @gig.likes.where(user: current_user).first_or_create

    respond_to do |format|
      format.html {redirect_to user_gig_path(@gig.user.slug, @gig.slug), notice: "Se ha guardado este Jale en tus favoritos"}
      format.js
    end
  end
  # DELETE /likes/1
  def destroy
    @gig.likes.where(user: current_user).destroy_all

    respond_to do |format|
      format.html {redirect_to user_gig_path(@gig.user.slug, @gig.slug), notice: "Se ha eliminado este Jale en tus favoritos"}
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_gig
      @gig = Gig.friendly.find(params[:gig_id])
    end

    # Only allow a trusted parameter "white list" through.
    def like_params
      gig = params.require(:like).permit(:gig_slug)
      like_params[gig] = Gig.friendly.find(gig)
      like_params[user] = current_user
      like_params
    end
end
