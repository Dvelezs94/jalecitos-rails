# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  layout "guest"
  prepend_before_action :check_captcha, only: [:create]
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    super
  end

  # POST /resource
  def create
    build_resource(sign_up_params.merge(lat: params[:sign_up_lat], lng: params[:sign_up_lon], address_name: params[:sign_up_address_name]))
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      if resource.errors.any?
        redirect_to new_user_registration_path, notice: "#{resource.errors.full_messages[0]}"
      else
        redirect_to new_user_registration_path, notice: "Algo ha salido mal con tu registro. Contacta a Soporte para mayor información."
      end
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  def update
   self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
   prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

   resource_updated = update_resource(resource, account_update_params)
   yield resource if block_given?
   if resource_updated
     flash[:success] = "La cuenta ha sido actualizada."
     bypass_sign_in resource, scope: resource_name
     redirect_to configuration_path(n)
   else
     clean_up_passwords resource
     set_minimum_password_length
     flash[:error] = "No se pudieron actualizar tus datos, intenta de nuevo."
     redirect_to configuration_path(collapse: "security")
   end
  end

  # DELETE /resource
  # def destroy
  #
  # end

  def disable
    #cant disable banned accounts
    if current_user.active?
      @success = current_user.update(status: "disabled")
      if @success
        current_user.invalidate_all_sessions!
        sign_out(current_user)
        flash[:success] = "Tu cuenta ha sido desactivada."
        redirect_to root_path
      else
        flash[:notice] = current_user.errors.full_messages.first
        redirect_to configuration_path(collapse: "account")
      end
    elsif current_user.banned?
      flash[:notice] = "No se pudo desactivar la cuenta ya que está bloqueada."
      redirect_to configuration_path(collapse: "account")
    else
      flash[:notice] = "No se pudo desactivar esta cuenta."
      redirect_to configuration_path(collapse: "account")
    end
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  def after_sign_up_path_for(resource)
     wizard_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    root_path
  end

  private
  def check_captcha
    unless verify_recaptcha
      self.resource = resource_class.new sign_up_params
      resource.validate # Look for any other validation errors besides Recaptcha
      flash[:error] = "Por favor, confirma que no eres un robot en tu registro."
      redirect_to after_inactive_sign_up_path_for(resource)
    end
  end
end
