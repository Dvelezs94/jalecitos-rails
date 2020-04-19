# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  layout "guest"
  after_action :set_cookie, only: :create

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
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

  # method used to set a cookie after successful sign in
  # lg stands for logged
  def set_cookie
    # cookie to know if the user is signed in
    cookies.permanent.signed[:lg] = rand
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def after_sign_in_path_for resource
    if check_if_banned(resource)
      sign_out resource
    else
      root_path
    end
    #if i am in localhost/sign_in path, redirect to localhost, otherwise, it will throw a too many times redirect error
    # (Rails.application.routes.recognize_path(request.referrer)[:controller] == "users/sessions")? root_path : request.referrer + "?review=true"
  end

  #this is just for accounts that have email and password, the filter of fb and google accounts is in omniauth_calbacks_controller
  # def check_if_banned_or_disabled(user)
  #   if user.banned?
  #     flash[:error] = "Esta cuenta está bloqueada, favor de comunicarte con soporte para más información"
  #     return true
  #   elsif user.disabled?
  #     flash[:error] = "Has deshabilitado esta cuenta, favor de comunicarte con soporte para más información "
  #     return true
  #   end
  # end
  def check_if_banned(user)
    if user.disabled?
      flash[:error] = "Has deshabilitado esta cuenta, favor de comunicarte con soporte para más información "
      return true
    end
  end
end
