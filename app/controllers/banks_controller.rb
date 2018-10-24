class BanksController < ApplicationController
  before_action :authenticate_user!
  before_action :init_openpay, only: [:create, :destroy]
  access user: [:create, :destroy]


  def create
    request_hash={
     "holder_name" => bank_params[:holder_name],
     "alias" => bank_params[:alias],
     "clabe" => bank_params[:clabe]
    }

    begin
      @bank_account.create(request_hash.to_hash, current_user.openpay_id)
      redirect_to root_path, success: 'La cuenta fue creada exitosamente.'
    rescue OpenpayTransactionException => e
        # e.http_code
        # e.error_code
        redirect_to root_path, warning: "#{e.description}, por favor intentalo de nuevo."
    end
  end


  def destroy
    @bank_account.delete(current_user.openpay_id, params[:bank_account_id])
    redirect_to root_path, success: 'La cuenta fue borrada exitosamente.'
  end

  private
    # Only allow a trusted parameter "white list" through.
    def bank_params
        params.require(:bank).permit(:holder_name, :alias, :clabe)
    end
    def init_openpay
      @openpay ||= OpenPay::Init::Openpay
      @bank_account = @openpay.create(:bankaccounts)
    end

end
