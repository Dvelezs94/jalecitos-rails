class OffersController < ApplicationController
  layout 'logged'
  include SanitizeParams
  include OffersHelper
  include OpenpayHelper
  before_action :authenticate_user!
  before_action :set_request
  before_action :allow_owner, only: :hire
  before_action :set_offer, only: [:edit, :update, :destroy, :hire]
  access all: [:show], user: :all
  before_action :check_banned, only: :create
  before_action :check_offer_ownership, only:[:edit, :update, :destroy]
  before_action :check_if_offered, only: :create
  before_action :deny_owner, only: [:new, :create]
  before_action :check_if_already_hired

  # GET /offers/new
  def new
    check_if_offered
    @offer = Offer.new
  end

  def hire
    @openpay_id = current_user.openpay_id
    @order = Order.new
    @user_cards = get_openpay_resource("card", @openpay_id)
    @billing_profiles = current_user.billing_profiles.enabled
    @price = calc_hire_view(@offer.price)
  end

  # GET /offers/1/edit
  def edit
  end

  # POST /offers
  def create
    @offer = Offer.new( sanitized_params( offer_params_create ) )
    if @offer.save
      create_notification(@offer.user, @offer.request.user, "oferto", @offer.request)
      OfferMailer.new_offer(@offer).deliver if @offer.request.user.transactional_emails
      redirect_to request_path(params[:request_id]), notice: 'La oferta ha sido creada con éxito.'
    else
      render :new
    end
  end

  # PATCH/PUT /offers/1
  def update
    if @offer.update( sanitized_params( offer_params_update ) )
      redirect_to request_path(params[:request_id]), notice: 'La oferta fue actualizada con éxito'
    else
      render :edit
    end
  end

  # DELETE /offers/1
  def destroy
    @offer.destroy
    redirect_to request_path(params[:request_id]), notice: 'Oferta destruida.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_offer
      @offer = Offer.find(params[:id])
    end

    def set_request
      @request = Request.friendly.find(params[:request_id])
    end

    def offer_params_update
      offer_params = params.require(:offer).permit(:description,
                                                   :price,
                                                   :hours
                                                  )
    end

    def offer_params_create
      offer_params = params.require(:offer).permit(:description,
                                                   :price,
                                                   :hours
                                                 ).merge(:request_id => @request.id, :user_id => current_user.id)
    end
    
    def check_offer_ownership
      if current_user != @offer.user
        redirect_to root_path
      end
    end

    def check_if_offered
      if has_offered(current_user.id)
        redirect_to request_path(params[:request_id]), notice: 'Ya ofertaste en este pedido.'
      end
    end

    def check_banned
      if @request.banned?
        redirect_to root_path, notice: "No puedes ofertar en este pedido"
        return
      end
    end
    # dont let the owner do certain things if the requester is he
    def deny_owner
      if current_user == @request.user
        redirect_to root_path, notice: "No puedes ofertar en este pedido"
        return
      end
    end

    def allow_owner
      if current_user != @request.user
        redirect_to root_path, notice: "No puedes acceder a esta ruta"
        return
      end
    end
    # function to check if the request has already hired someone, so they cannnot make changes to offers after that
    def check_if_already_hired
      if @request.employee.present?
        redirect_to root_path, notice: "No puedes acceder a esta ruta"
        return
      end
    end
end
