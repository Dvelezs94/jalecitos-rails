class VerificationsController < ApplicationController
  layout 'logged'
  before_action :authenticate_user!
  before_action :check_current_verifications
  before_action :set_verification, only: [:approve, :deny]
  before_action :verify_previous_work, only: [:new, :create]
  access user: [:new, :create], admin: [:approve, :deny, :cancel]

  def new
    @verification = Verification.new
  end

  def create
    @verification = Verification.new(verification_params)
    if @verification.save
      redirect_to root_path, notice: 'Tu solicitud a sido enviada. Se te notificara por correo el estado en un máximo de 72 Hrs'
    else
      render :new
    end
  end


  def approve
    @verification.granted!
    redirect_to root_path, notice: "El usuario ha sido aprovado"
  end

  def deny
    @verification.update!(denial_details: params[:verification][:denial_details])
    @verification.denied!
    redirect_to root_path, notice: "El usuario ha sido denegado y notificado"
  end

  def cancel
    @user = User.find_by_slug(params[:id])
    @user.update(verified: false)
    redirect_to root_path, notice: "Se ha actualizado el usuario"
  end

  private

  def set_verification
    @verification = Verification.find(params[:id])
  end

  def verification_params
    verification_params = params.require(:verification).permit({identification: []},
                                :curp,
                                :address,
                                :criminal_letter
                              ).merge(:user_id => current_user.id)
  end

  def check_current_verifications
    if (current_user.verifications.granted.any?)
      redirect_to root_path, notice: "Ya te has verificado"
      return false
    elsif (current_user.verifications.pending.any?)
      redirect_to root_path, notice: "Ya tienes una verificacion en proceso"
      return false
    end
  end

  def verify_previous_work
    if current_user.sales.completed.length <= 10
      redirect_to configuration_path(collapse: "account"), notice: "Debes tener más de 10 ventas para solicitar una verificación"
      return false
    end
  end
end
