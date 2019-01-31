# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    auth_options = { :recall => redirect_validation, :scope => :user}
    resource = warden.authenticate!(auth_options)
    super
  end

  # POST /resource/sign_in
  def create
    auth_options = { :recall => redirect_validation, :scope => :user }
    resource = warden.authenticate!(auth_options)
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end


  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  def redirect_validation
    params[:from_mobile].present? ? "mobiles#sign_in" : 'pages#home'
  end
end
