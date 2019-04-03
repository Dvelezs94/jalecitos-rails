class BillingProfilesController < ApplicationController
  include RefererFunctions
  before_action :authenticate_user!
  access user: :all, admin: :all
  before_action :set_billing_profile, only: [:destroy]
  before_action :verify_ownership, only: [:destroy]

  def create
    @billing_profile = BillingProfile.new(billing_profile_params)
    @billing_profiles_count = current_user.billing_profiles.enabled.count
    if @billing_profiles_count > 0
      redirect_to configuration_path(collapse: "billing"), alert: "Solo puedes tener 1 RFC registrado a la vez."
    else
      if @billing_profile.save
        flash[:success] = "El perfil fue creado con exito."
      else
        flash[:alert] = "Error al crear perfil."
      end
      referer_params = referer_params(request.referer)
      if referer_params["package_id"].join("") != ""
        package = Package.find_by_slug(referer_params["package_id"])
        redirect_to hire_package_path(package)
      elsif referer_params["offer_id"].join("") != ""
        offer = Offer.find_by_id(referer_params["offer_id"])
        redirect_to hire_request_offer_path(offer.request, offer)
      else
        redirect_to configuration_path(collapse: "billing")
      end
    end
  end

  def destroy
    redirect_to configuration_path(collapse: "billing"), notice: "Se ha eliminado el perfil de facturación." if @billing_profile.update_attribute(:status, 1)
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
