class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :update_sign_in_at_periodically
  UPDATE_LOGIN_PERIOD = 1.hours

  protected
 def configure_permitted_parameters
   devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :password, :password_confirmation])
   devise_parameter_sanitizer.permit(:account_update, keys: [:name, :country])
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

  def create_notification(user, recipient, message, model, query_url=nil, review_id=nil)
    Notification.create!(recipient: recipient, user: user, action: message, notifiable: model, query_url: query_url, review_id: review_id)
  end
  #Devise redirects
  def after_sign_in_path_for(resource)
    request.referrer + "?review=true" || root_path
  end

  #behave as request of "user"
  def self.renderer_with_signed_in_user(user)
    ActionController::Renderer::RACK_KEY_TRANSLATION['warden'] ||= 'warden'
    proxy = Warden::Proxy.new({}, Warden::Manager.new({})).tap { |i|
      i.set_user(user, scope: :user, store: false, run_callbacks: false)
    }
    renderer.new('warden' => proxy)
  end
end
