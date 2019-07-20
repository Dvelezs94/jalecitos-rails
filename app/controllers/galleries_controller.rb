class GalleriesController < ApplicationController
  layout 'logged'
  access user: :all
  before_action :set_item, only: [:create, :save_video]
  before_action :set_item_destroy, only: [:destroy]
  before_action :check_item_ownership, only: [:create, :destroy, :save_video]
  before_action :check_if_content, only: [:create]
  skip_before_action :verify_authenticity_token

  def create
    @uploaded = (params[:gig].present?)? params[:gig][:images] : params[:request][:images]#get uploaded image
    @uploaded[0].original_filename = SecureRandom.uuid + File.extname(@uploaded[0].original_filename) #generate a name (useful when duplicated)
    puts @uploaded[0].original_filename
    begin
    @item.with_lock do #one update at time
      @images = @item.images #get current images
      @images.each do |image| #verify its unique
        begin
          raise if @uploaded[0].original_filename == image.file.filename
        rescue
          @uploaded[0].original_filename = SecureRandom.uuid + File.extname(@uploaded[0].original_filename) #generate new one if not unique
          retry
        end
      end
      @images += @uploaded #append new image
      @item.images = @images
      @success = true if @item.save  #save all
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

  def save_video #also for destroying
    if @item.youtube_url != params[:gig][:youtube_url]
      @success = @item.update(:youtube_url => params[:gig][:youtube_url])
    end
  end

  def destroy
    @item.with_lock do #one delete at time
      @images = @item.images #get all the images
      @images.delete_if do |image| #delete the matching image
        true if File.basename(image.file.filename, ".*") == params[:id] #compare filenames without extension
      end
      if @images.count == 0 #if there is no image left...
        @item.remove_images! #remove everything
      else
        @item.images = @images  #save with image removed
      end
      @success = true if @item.save
    end
    head :no_content #response with no content
  end

  private
  def set_item
    if params[:gig_id].present?
      @item = Gig.find(params[:gig_id])
    else
      @item = Request.find(params[:req_id])
    end
  end


  def check_item_ownership
    head(:no_content) if (current_user.nil? || current_user.id != @item.user_id)
  end

  def set_item_destroy
    model = params[:class].constantize
    @item = model.find(params[:item_id])
  end
  def check_if_content
    if params[:gig].nil? && params[:request].nil?  #no images (just clicking next)
      if params[:gig_id].present?
        @next = true
        render "create"
      end
      if params[:req_id].present?
        @req_end = true
        render "create"
      end
    end
  end

  def gig_params
    gig_params = params.require(:gig).permit(
                                {images: []}
                              )
  end


end
