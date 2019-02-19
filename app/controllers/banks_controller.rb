class BanksController < ApplicationController
  include OpenpayHelper
  include UsersHelper
  before_action :authenticate_user!
  before_action :set_user, only: [:create, :destroy]
  before_action only: [:create, :destroy] do
    init_openpay("bank")
  end
  access user: [:create, :destroy]
  before_action :check_user_ownership, only:[:create, :destroy]


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
        flash[:error] = "#{e.description}, por favor intentalo de nuevo más tarde."
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
end
