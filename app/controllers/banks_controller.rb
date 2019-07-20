class BanksController < ApplicationController
  include OpenpayHelper
  include UsersHelper
  access user: [:create, :destroy]
  before_action :authenticate_user!
  before_action :set_user, only: [:create, :destroy]
  before_action only: [:create, :destroy] do
    init_openpay("bank")
  end
  before_action :validate_max_banks, only: :create
  before_action :check_user_ownership, only:[:create, :destroy]
  before_action :verify_personal_information, only: :create


  def create
    request_hash={
     "holder_name" => bank_params[:bank_holder_name],
     "alias" => bank_params[:alias],
     "clabe" => bank_params[:clabe]
    }

    begin
      @bank_account.create(request_hash.to_hash, current_user.openpay_id)
      flash[:success] = 'La cuenta fue creada exitosamente.'
      redirect_to configuration_path(collapse: "withdraw")
    rescue OpenpayTransactionException => e
        # e.http_code
        # e.error_code
        flash[:error] = "#{e.description}, por favor inténtalo de nuevo más tarde."
        redirect_to configuration_path(collapse: "withdraw")
    end
  end


  def destroy
    begin
      @bank_account.delete(current_user.openpay_id, params[:id])
      flash[:success] = 'La cuenta fue borrada exitosamente.'
      redirect_to configuration_path(collapse: "withdraw")
    rescue OpenpayTransactionException => e
      flash[:error] = "#{e.description}, por favor intentalo de nuevo más tarde."
      redirect_to configuration_path(collapse: "withdraw")
    end
  end

  private
    # Only allow a trusted parameter "white list" through.
    def bank_params
        params.permit(:bank_holder_name, :alias, :clabe)
    end

    def set_user
      @user = current_user
    end

    def check_user_ownership
      if ! my_profile
        flash[:error] = "No tienes permisos para acceder aquí"
        redirect_to root_path
      end
    end

    # Each user can have a max of 3 banks
    def validate_max_banks
      @current_avail_banks = get_openpay_resource("bank", current_user.openpay_id).count
      if @current_avail_banks < 3
        return true
      else
        flash[:error] = "Solo puedes tener un maximo de 3 bancos. Elimina una cuenta para poder proceder."
        redirect_to configuration_path(collapse: "withdraw")
        return false
      end
    end

    def verify_personal_information
      if current_user.name.blank?
        flash[:error] = "Asegurate de tener tu nombre completo en Jalecitos para poder agregar una cuenta bancaria"
        redirect_to configuration_path(bestFocusAfterReload: "change_user_name")
      end
    end
end
