class UsersController < ApplicationController
  include OpenpayHelper
  include SetLayout
  include GetUser
  include UsersHelper
  include ReportFunctions
  respond_to :html, :json, :js
  layout :set_layout
  before_action :check_if_my_profile, only: :show
  before_action :set_user, only: [:show]
  before_action :set_user_config, only: [:configuration]
  access all: [:show], user: [:update_user, :configuration, :my_account, :send_new_confirmation_email]


  def configuration
      @openpay_id = @user.openpay_id
      @user_banks = get_openpay_resource("bank", @openpay_id)
      @user_cards = get_openpay_resource("card", @openpay_id)
      @roles = {:employee => "Vendedor", :employer => "Comprador"}
      @billing_profiles = current_user.billing_profiles.enabled
      @billing_profile = BillingProfile.new
    end

  def show
    if params[:reviews]
      get_reviews(true)
    else
      report_options
      get_reviews
      get_gigs
      Searchkick.multi_search([@gigs, @reviews])
    end
  end

  def my_account
    @user = current_user
    if params[:reviews]
      get_reviews(true)
    elsif params[:requests]
      get_requests(true)
    else
      report_options
      get_reviews
      get_gigs
      get_requests
      Searchkick.multi_search([@gigs, @requests, @reviews])
    end
    render "show"
  end

  # PATCH/PUT /users/1
  #aqui la parte del usuario de la url no importa, ya que aqui adentro se usa current_user, esto para darle seguridad a los usuarios de solo editar su perfil
  def update_user
    if params[:user]["name"]
      update_openpay_name(params[:user]["name"])
    end
    @success = true if current_user.update_attributes(user_params)
    respond_to do |format|
      # if params[:user]["alias"]
      #   # flash[:success] = 'Tu alias ha sido actualizado.'
      #   format.json  { render :json => { :redirect => configuration_path } }
      #labels and image of user
        format.js {
          if params[:user][:image].present?
            @message = "Tu imagen de perfil se ha actualizado."
          else
            @message = "Tus etiquetas se han actualizado."
            puts @message
          end
         }
        #best_in_place
        format.json { respond_with_bip(current_user) }
        #changing location of config and mobile use this, and image of user
        format.html {
          flash[:success] = "Tu ubicación se ha actualizado."
          redirect_to request.referrer
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
      @user = User.friendly.find(params[:id])
    end

    def set_user_config
      @user = current_user
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name,
                                   :alias,
                                   :image,
                                   :bio,
                                   :age,
                                   :available,
                                   :city_id,
                                   :roles_word,
                                   :tag_list,
                                   :transactional_emails,
                                   :marketing_emails
                                 )
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
        flash[:error] = "Error interno, el usuario no pudo ser actualizado"
        redirect_to configuration_path
        false
      end
    end
end
