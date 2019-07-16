class AllyCodesController < ApplicationController
  before_action :authenticate_user!
  access admin: [:create], user: [:trade]
  before_action :verify_already_ally, only: [:trade]
  before_action :set_ally_code, only: [:trade]

  # POST /allycodes
  def create
    @ally_code = AllyCode.new(ally_code_params)
    begin
      @ally_code.save
      redirect_to ally_codes_admins_path, notice: "El codigo para #{@ally_code.name} se creo: #{@ally_code.token}"
    rescue => e
      redirect_to ally_codes_admins_path, alert: "Error #{e}"
    end
  end

  def trade
    if @ally_code.enabled && @ally_code.times_left > 0
      if current_user.update!(ally_code: @ally_code)
        flash[:success] = "Tu código ha sido aplicado"
      else
        flash[:alert] = "El código no pudo ser utilizado."
      end
    else
      flash[:alert] = "El código está vencido o no tiene mas canjes disponibles."
    end
    redirect_to configuration_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_ally_code
      begin
        @ally_code = AllyCode.find_by_token(params[:code_id])
        raise "El código no existe." if @ally_code.nil?
      rescue RuntimeError => e
        redirect_to configuration_path, alert: e
      end
    end

    # Only allow a trusted parameter "white list" through.
    def ally_code_params
       ally_code_params = params.require(:ally_code).permit(:name, :times_left, :level_enabled, :token)
       ally_code_params[:token] = SecureRandom.urlsafe_base64(6) if ally_code_params[:token].blank?
       ally_code_params
    end

    def verify_already_ally
      if current_user.ally_code.present?
        redirect_to configuration_path, notice: "Ya tienes un código de aliado existente"
      end
    end
end
