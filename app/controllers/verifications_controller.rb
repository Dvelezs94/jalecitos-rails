class VerificationsController < ApplicationController
  layout 'logged'
  before_action :authenticate_user!
  before_action :check_current_verifications
  before_action :set_verification, only: [:approve, :deny]
  access user: [:new, :create], admin: [:approve, :deny]

  def new
    @verification = Verification.new
  end

  def create
    @verification = Verification.new(verification_params)
    if @verification.save
      redirect_to root_path, notice: 'Tu solicitud a sido enviada. Se te notificara por correo el estado en un maximo de 72 Hrs'
    else
      render :new
    end
  end


  def approve
    @verification.granted!
    redirect_to root_path, notice: "El usuario ha sido aprovado"
  end

  def deny
    @verification.denied!
    redirect_to root_path, notice: "El usuario ha sido denegado y notificado"
  end

  private

  def set_verification
    @verification = Verification.find(params[:id])
  end

  def verification_params
    verification_params = params.require(:verification).permit(:identification,
                                :curp,
                                :address,
                                :criminal_letter
                              )
    verification_params = set_owner(verification_params)
  end

  def set_owner parameters
    parameters[:user_id] = current_user.id
    parameters
  end

  def check_current_verifications
    if (current_user.verifications.granted.any?) || (current_user.verifications.pending.any?)
      redirect_to root_path, notice: "Ya tienes una verificacion en proceso"
      return false
    end
  end
end