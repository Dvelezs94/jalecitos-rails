# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    auth_options = { :recall => 'pages#home', :scope => :user }
    resource = warden.authenticate!(auth_options)
    super
  end

  # POST /resource/sign_in
  def create
    auth_options = { :recall => 'pages#home', :scope => :user }
    resource = warden.authenticate!(auth_options)
    # Set cookie for Action cable
    cookies.signed[:user_id] = current_user.id
    super
  end

  # DELETE /resource/sign_out
  def destroy
    # Delete action cable cookie
    cookies.delete :user_id
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
