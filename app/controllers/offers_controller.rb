class OffersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_offer, only: [:show, :edit, :update, :destroy]
  access all: [:show], user: :all
  before_action :check_offer_ownership, only:[:edit, :update, :destroy]
  include OffersHelper

  # GET /offers
  def index
    redirect_to root_path
  end

  # GET /offers/1
  def show
    redirect_to request_path(params[:request_id])
  end

  # GET /offers/new
  def new
    @request = Request.find(params[:request_id])
    if has_offered(current_user.id)
      redirect_to request_path(params[:request_id]), notice: 'You already offered on this request'
    end
    @offer = Offer.new
  end

  # GET /offers/1/edit
  def edit
  end

  # POST /offers
  def create
    @offer = Offer.new(offer_params)

    if @offer.save
      redirect_to request_path(params[:request_id]), notice: 'Offer was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /offers/1
  def update
    if @offer.update(offer_params)
      redirect_to request_path(params[:request_id]), notice: 'Offer was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /offers/1
  def destroy
    @offer.destroy
    redirect_to request_path(params[:request_id]), notice: 'Offer was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offer
      @offer = Offer.find(params[:id])
    end

    def offer_params
      offer_params = params.require(:offer).permit(:description,
                                                   :price,
                                                   :hours
                                                  )
      offer_params = set_owner(offer_params)
    end

    def set_owner parameters
      parameters[:request_id] = params[:request_id]
      parameters[:user_id] = current_user.id
      parameters
    end

    def check_offer_ownership
      if current_user.id != @offer.user_id
        redirect_to root_path
      end
    end
end
