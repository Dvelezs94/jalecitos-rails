class BillingProfilesController < ApplicationController
  before_action :authenticate_user!
  access user: :all, admin: :all
  before_action :set_billing_profile, only: [:destroy]
  before_action :verify_ownership, only: [:destroy]

  def create
    @billing_profile = BillingProfile.new(billing_profile_params)

    if @billing_profile.save
      redirect_to "#{user_config_path}#billingprofile", notice: "El perfil fue creado con exito."
    else
      redirect_to "#{user_config_path}#billingprofile", alert: "Error al crear perfil."
    end
  end

  def destroy
    @billing_profile.update_attribute(:status, 1)
  end

  private
  def billing_profile_params
    billing_profile_params = params.require(:billing_profile).permit(:address, :profile, :zip_code, :rfc, :name)
    billing_profile_params[:user] = current_user
    billing_profile_params
  end

  def set_billing_profile
    @billing_profile = BillingProfile.find(params[:id])
  end

  def verify_ownership
    if @billing_profile.user != current_user
      redirect_to root_path, alert: "No tienes acceso a este perfil de factura"
    end
  end
end
