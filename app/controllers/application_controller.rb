class ApplicationController < ActionController::Base
  before_action :check_if_user_banned, if: :not_in_home?
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :update_sign_in_at_periodically
  UPDATE_LOGIN_PERIOD = 1.hours
  include ApplicationHelper

  protected
 def configure_permitted_parameters
   devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :password, :password_confirmation])
   devise_parameter_sanitizer.permit(:account_update, keys: [:name, :country])
 end

 def check_if_user_banned #just if not in devise controller because other way its infinite loop
   if current_user && current_user.banned?
     sign_out(current_user)
     redirect_to(cookies.permanent.signed[:mb].present? ? mobile_sign_in_path : root_path)
   end
 end

def not_in_home? #just log out the banned user if the request is html format and location is different from the home and devise controllers
  #cant logout on home because if i log out it doesnt redirect because i can go home without an user, so mobile users goes to desktop user home at logout, and its wrong
  unless (params[:controller] == "pages" && params[:action] == "home") || devise_controller? || ! request.format.html?
    return true
  else
    return false
  end
end

 def update_sign_in_at_periodically
    # use session cookie to avoid hammering the database
    if !session[:last_login_update_at] or session[:last_login_update_at] < UPDATE_LOGIN_PERIOD.ago
      session[:last_login_update_at] = Time.now
      if user_signed_in? and current_user.current_sign_in_at < 1.minute.ago # prevents double logins
        sign_in(current_user, :force => true)
      end
    end
  end


  #behave as request of "user"
  def self.renderer_with_signed_in_user(user)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap { |i|
      i.set_user(user, scope: :user, store: false, run_callbacks: false)
    }
    renderer.new('warden' => proxy)
  end

  def is_number? string
    true if Float(string) rescue false
  end

end
