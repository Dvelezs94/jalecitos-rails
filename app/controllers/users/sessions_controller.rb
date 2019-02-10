# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  after_action :set_cookie, only: :create

  # GET /resource/sign_in
  def new
    auth_options = { :recall => redirect_validation, :scope => :user }
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
    cookies.delete :lg
  end


  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
  private

  def redirect_validation
    params[:from_mobile].present? ? "mobiles#sign_in" : 'pages#home'
  end

  # method used to set a cookie after successful sign in
  # lg stands for logged
  def set_cookie
    # cookie to know if the user is signed in
    cookies.permanent.signed[:lg] = rand
  end

  def after_sign_out_path_for(resource)
    if cookies.signed[:mb]
      mobile_sign_in_path
    else
      root_path
    end
  end

  def after_sign_in_path_for resource
    params[:from_mobile].present? ? root_path(notifications: "enable", review: "true") : root_path(review: "true")
    #if i am in localhost/sign_in path, redirect to localhost, otherwise, it will throw a too many times redirect error
    # (Rails.application.routes.recognize_path(request.referrer)[:controller] == "users/sessions")? root_path : request.referrer + "?review=true"
  end
end
