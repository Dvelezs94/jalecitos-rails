# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  layout "guest"
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
     sign_in(resource)
     set_flash_message!(:notice, :confirmed)
     redirect_to configuration_path(wizard: "true")
    else
     redirect_to root_path, notice: "Algo ha salido mal con tu registro."
    end
  end

  private
  protected

    def after_resending_confirmation_instructions_path_for(resource_name)
      platform_redirect_root_path
    end

    def after_confirmation_path_for(resource_name, resource)
      platform_redirect_root_path
    end
end
