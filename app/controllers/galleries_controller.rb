class GalleriesController < ApplicationController
  layout 'logged'
  before_action :set_gig, only: [:index, :create]
  before_action :check_gig_ownership, only:[:index, :create]
  access user: :all

  def index
  end

  def create
    @images = @gig.images #save current images
    @images += params[:gig][:images] #append new image
    @gig.images = @images  #save all
    @success = true if @gig.save
  end

  private
  def set_gig
    @gig = Gig.friendly.find(params[:gig_id])
  end

  def check_gig_ownership
    (current_user.nil? || current_user.id != @gig.user_id) ? redirect_to(root_path) : nil
  end

  def gig_params
    gig_params = params.require(:gig).permit(
                                {images: []}
                              )
  end


end
