# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  layout :set_layout

  def after_sending_reset_password_instructions_path_for(resource_name)
    return platform_redirect_root_path
  end
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end
  private
  def set_layout
    cookies.signed[:mb] ? "mobile" : "guest"
  end
  # protected

   def after_resetting_password_path_for(resource)
     return platform_redirect_root_path
   end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
