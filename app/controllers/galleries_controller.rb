class GalleriesController < ApplicationController
  layout 'logged'
  before_action :set_gig, only: [:create, :destroy]
  before_action :check_gig_ownership, only: [:create, :destroy]
  before_action :check_if_content, only: [:create]
  skip_before_action :verify_authenticity_token

  access user: :all


  def create
    @uploaded = params[:gig][:images] #get uploaded image
    @uploaded[0].original_filename = SecureRandom.uuid + File.extname(@uploaded[0].original_filename) #generate a name (useful when duplicated)
    begin
    @gig.with_lock do #one update at time
      @images = @gig.images #get current images
      @images.each do |image| #verify its unique
        begin
          raise if @uploaded[0].original_filename == image.file.filename
        rescue
          @uploaded[0].original_filename = SecureRandom.uuid + File.extname(@uploaded[0].original_filename) #generate new one if not unique
          retry
        end
      end
      @images += @uploaded #append new image
      @gig.images = @images
      @success = true if @gig.save  #save all
    end
    rescue ActiveRecord::QueryCanceled => error
      @retries ||= 0
      if @retries < 2
        @retries += 1
        retry
      else
        raise error
      end
    end
  end

  def destroy
    @gig.with_lock do #one delete at time
      @images = @gig.images #get all the images
      @images.delete_if do |image| #delete the matching image
        true if File.basename(image.file.filename, ".*") == params[:id] #compare filenames without extension
      end
      if @images.count == 0 #if there is no image left...
        @gig.remove_images! #remove everything
      else
        @gig.images = @images  #save with image removed
      end
      @success = true if @gig.save
    end
    head :no_content #response with no content
  end

  private
  def set_gig
    @gig = Gig.find(params[:gig_id])
  end


  def check_gig_ownership
    head(:no_content) if (current_user.nil? || current_user.id != @gig.user_id)
  end

  def check_if_content
    if params[:gig].nil? #no images (just clicking next)
      @next = true
      render "create"
    end
  end

  def gig_params
    gig_params = params.require(:gig).permit(
                                {images: []}
                              )
  end


end
