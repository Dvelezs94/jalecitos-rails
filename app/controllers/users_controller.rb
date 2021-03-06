class UsersController < ApplicationController

  include SetLayout
  include GetUser
  include UsersHelper
  respond_to :html, :json, :js
  layout :set_layout
  access all: [:show], user: [:update_user, :configuration, :my_account, :send_new_confirmation_email]
  before_action :check_if_my_profile, only: :show
  before_action :set_user, only: [:show]
  before_action :set_user_config, only: [:configuration]


  def configuration
      # no hire
      # @openpay_id = @user.openpay_id
      # @user_banks = get_openpay_resource("bank", @openpay_id)
      # @user_cards = get_openpay_resource("card", @openpay_id)
      @roles = {:employee => "Vendedor", :employer => "Comprador"}
      @billing_profiles = current_user.billing_profiles.enabled
      @billing_profile = BillingProfile.new
    end

  def show
    if params[:reviews]
      get_reviews
    elsif params[:gigs]
      get_gigs
    else
      get_reviews
      get_gigs
    end
  end

  def my_account
    @user = current_user
    if params[:reviews]
      get_reviews
    elsif params[:requests]
      get_requests
    elsif params[:gigs]
      get_gigs
    else
      get_reviews
      get_gigs
      get_requests
    end
    render "show"
  end

  # PATCH/PUT /users/1
  #aqui la parte del usuario de la url no importa, ya que aqui adentro se usa current_user, esto para darle seguridad a los usuarios de solo editar su perfil
  def update_user
    @success = current_user.update(user_params)
    respond_to do |format|
        format.js {
          #response in partial
         }
        #changing location of config and mobile use this, and image of user
        format.html {
         }
    end

  end

  def send_new_confirmation_email
    if Time.now - current_user.confirmation_sent_at > 30.minute
      if current_user.confirmed_at.nil?
        begin
          current_user.send_confirmation_instructions
          current_user.update(confirmation_sent_at: Time.now)
          flash[:success] = "Instrucciones enviadas. Asegurate de revisar tu bandeja de spam"
        rescue
          flash[:error] = "Hubo un error al enviar tu mail de confirmacion. Contactanos para solucionarlo"
        end
      end
    else
      flash[:error] = "Favor de esperar #{((current_user.confirmation_sent_at+30.minute - Time.now)/1.minute).to_i} minutos antes de solicitar un nuevo mail de confirmacion."
    end
    redirect_to root_path
  end


  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by(slug: params[:id])
      if @user.nil?
        flash[:error] = "El usuario no existe"
        redirect_to root_path()
      end
    end

    def set_user_config
      @user = current_user
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      user_params = params.require(:user).permit(:name,
                                   :alias,
                                   :image,
                                   :bio,
                                   :age,
                                   :lat,
                                   :lng,
                                   :address_name,
                                   # :roles_word,
                                   :tag_list,
                                   :transactional_emails,
                                   # :marketing_emails,
                                   :whatsapp_enabled,
                                   :phone_number,
                                   :birth,
                                   :website,
                                   :facebook,
                                   :instagram
                                 )
      user_params[:phone_number] = "" if user_params[:phone_number].present? && user_params[:phone_number].split(" ").length < 2 #this tells me that maybe the string just has the code that is put in the frontend input
      return user_params
    end

    def check_if_my_profile
      if user_signed_in?
        redirect_to my_account_users_path if current_user.slug == params[:id]
      end
    end

    def update_openpay_name (name)
      init_openpay("customer")
      request_hash = {
                      "name": name,
                      "email": current_user.email
                      }
      begin
        @customer.update(request_hash, current_user.openpay_id)
      rescue
        flash[:error] = "Error interno, el nombre no pudo ser actualizado, por favor, intente m??s tarde"
        redirect_to configuration_path
        false
      end
    end
end
