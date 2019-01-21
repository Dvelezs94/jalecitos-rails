class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    #@user = User.from_omniauth(request.env["omniauth.auth"])
    @auth = request.env["omniauth.auth"]

    if User.exists?(email: @auth.info.email)
      @user = User.find_or_initialize_by(provider: @auth.provider, email: @auth.info.email, password: Devise.friendly_token[0,20], name: @auth.info.name, image: @auth.info.image)
      @user.skip_confirmation!
      @user.save
    else
      @user = User.find_by_email(@auth.info.email)
    end

    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url, notice: "Error al tratar de acceder"
    end
  end

  def failure
    redirect_to root_path, notice: "Error, tu registro no pudo ser completado"
  end
end
