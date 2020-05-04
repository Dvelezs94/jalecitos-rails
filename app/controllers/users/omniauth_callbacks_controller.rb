class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable
  def facebook
    generic_auth
  end

  def google_oauth2
    generic_auth
  end

  def failure
    redirect_to new_user_session_path, notice: "Error, tu registro no pudo ser completado ya que puede que ya exista una cuenta con este correo."
  end

  def log_in_and_remember(user)
    remember_me(user)
    sign_in(user)
    cookies.permanent.signed[:lg] = rand
  end

  def generic_auth
    @auth = request.env["omniauth.auth"]
    @user = User.find_by_email(@auth.info.email)
    if ! @user
      if @auth.info.email.present?
        @new_user = User.new(provider: @auth.provider, email: @auth.info.email, password: Devise.friendly_token[0,20], name: @auth.info.name, image: @auth.info.image, lat: @mylat, lng: @mylng, address_name: @myaddress)
        @new_user.skip_confirmation!
        success = @new_user.save
        if success
          log_in_and_remember(@new_user)
          #  the z is just to fix the fb issue that is appending #_=_ to the last url param
          redirect_to wizard_path
        else
          flash[:notice] = "Ha ocurrido un error al tratar de crear tu cuenta, inténtalo de nuevo. Si el error persiste, por favor, contacta a soporte."
          redirect_to new_user_registration_path
        end
      else
        flash[:notice] = "No se permiten cuentas de Facebook sin correo electronico."
        redirect_to new_user_registration_path
      end
    # if the user already exists, just log in
    elsif @user.persisted?
      if check_if_banned(@user)
        redirect_to root_path
      else
        log_in_and_remember(@user)
        #  the z is just to fix the fb issue that is appending #_=_ to the last url param
        redirect_to root_path(notifications: "enable", z: "e")
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url, notice: "Error al tratar de acceder"
    end
  end
  private
  #this is for fb and google accounts
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
